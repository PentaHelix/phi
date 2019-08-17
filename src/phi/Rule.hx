package phi;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;

#if !macro
@:autoBuild(phi.Rule.build())
interface Rule<T:{}> {
  public function tick (): Void;
  public function match (e: Entity): Void;
  public function onWarp (u: Universe): Void;
  public function onMatched (t: T, e: Entity): Void;
  public function onUnmatched (t: T, e: Entity): Void;

  public function removeEntity (e: Entity): Void;
}

#else

class Rule {
  public static function build () {
    var fields: Array<Field> = Context.getBuildFields();
    var type = Context.getLocalType();
    var t: haxe.macro.Type;
    var ct: haxe.macro.ComplexType;
    switch(type) {
      case TInst(classType, _):
        t = Context.follow(classType.get().interfaces[0].params[0]);
        ct = Context.toComplexType(t);
      default:
    }

    // add entities field
    fields.push({
      name: 'entities',
      kind: FVar(
        TPath({
          name: 'IntMap',
          pack: ['haxe', 'ds'],
          params: [
            TPType(ct)
          ]
        }),
        macro new haxe.ds.IntMap<$ct>()
      ),
      access: [APublic],
      meta: null,
      pos: Context.currentPos(),
    });

    var hasConstructor = false;
    var hasOnWarp = false;
    var hasOnMatched = false;
    var hasOnUnmatched = false;
    var hasTick = false;

    for (field in fields) {
      if (field.name == 'new') hasConstructor = true;
      if (field.name == 'onWarp') hasOnWarp = true;
      if (field.name == 'onMatched') hasOnMatched = true;
      if (field.name == 'onUnmatched') hasOnUnmatched = true;
      if (field.name == 'tick') hasTick = true;
    }

    if (!hasConstructor) fields.push(constructor());
    if (!hasOnWarp) fields.push(onWarp());
    if (!hasOnMatched) fields.push(onMatched(ct));
    if (!hasOnUnmatched) fields.push(onUnmatched(ct));
    if (!hasTick) fields.push(tick());

    fields.push(mask(ct));
    fields.push(matcher(ct));
    fields.push(remover());
    return fields;
  }

  private static function constructor (): Field {
    return {
      name: 'new',
      kind: FFun({
        args: [],
        ret: macro : Void,
        expr: macro {}
      }),
      pos: Context.currentPos(),
      access: [APublic]
    };
  }

  private static function onWarp (): Field {
    return {
      name: 'onWarp',
      kind: FFun({
        args: [
          {
            name: 'u',
            type: macro : phi.Universe
          }
        ],
        ret: macro : Void,
        expr: macro {}
      }),
      pos: Context.currentPos(),
      access: [APublic]
    };
  }

  private static function onMatched (ct: ComplexType): Field {
    return {
      name: 'onMatched',
      kind: FFun({
        args: [
          {
            name: 'e',
            type: ct
          },
          {
            name: 'entity',
            type: macro : phi.Entity
          }
        ],
        ret: macro : Void,
        expr: macro {}
      }),
      pos: Context.currentPos(),
      access: [APublic]
    };
  }

  private static function onUnmatched (ct: ComplexType): Field {
    return {
      name: 'onUnmatched',
      kind: FFun({
        args: [
          {
            name: 'e',
            type: ct
          },
          {
            name: 'entity',
            type: macro : phi.Entity
          }
        ],
        ret: macro : Void,
        expr: macro {}
      }),
      pos: Context.currentPos(),
      access: [APublic]
    };
  }

  private static function tick (): Field {
    return {
      name: 'tick',
      kind: FFun({
        args: [],
        ret: macro : Void,
        expr: macro {}
      }),
      pos: Context.currentPos(),
      access: [APublic]
    };
  }

  private static function matcher (t: haxe.macro.ComplexType): Field {
    var mask: Traits;
    var objFields: Array<ObjectField> = [];
    var fields: Array<Field> = [];
    switch (t) {
      case TAnonymous(f):
        fields = f;
      default: 
    }

    for (field in fields) {
      if (!field.meta.exists(t -> t.name == ':trait')) continue;
      switch (field.kind) {
        case FVar(fieldType):
        objFields.push({
          field: field.name,
          expr: {
            expr: ECast(macro entity.getTrait($v{getTypeIdOfType(fieldType)}), null),
            pos: Context.currentPos()
          }
        });
        default: 
      }
    }
 
    var objDecl:Expr = {
      expr: EObjectDecl(objFields),
      pos: Context.currentPos()
    };

    return {
      name: 'match',
      pos: Context.currentPos(),
      access: [APublic],
      kind: FFun({
        args: [{
          name: 'entity',
          meta: null,
          opt: false,
          value: null,
          type: TPath({
            name: 'Entity',
            pack: ['phi'],
            params: null,
            sub: null
          })
        }],
        ret: TPath({
          name: 'Void',
          pack: [],
          params: null,
          sub: null
        }),
        params: null,
        expr: macro {
          if (phi.Game.entities.get(entity).traits.match(this.mask)) {
            if (!this.entities.exists(entity)) {
              var e = ${objDecl};
              this.entities.set(entity, e);
              this.onMatched(e, entity);
            }
          } else {
            if (this.entities.exists(entity)) {
              this.onUnmatched(this.entities.get(entity), entity);
              this.entities.remove(entity);
            }
          }
        }
      })
    };
  }

  private static function mask (ct: ComplexType): Field {
    var fields: Array<Field> = [];
    switch (ct) {
      case TAnonymous(f):
        fields = f.filter(f -> f.meta.exists(t -> t.name == ':trait'));
      default: 
    }

    return {
      name: 'mask',
      pos: Context.currentPos(),
      access: [APublic],
      kind: FVar(
        TPath({
          name: 'Traits',
          pack: ['phi']
        }),
        macro {
          new phi.Traits($v{fields.map(field -> getTypeId(field))});
        }
      )
    }
  }

  private static function remover (): Field {
    return {
      name: 'removeEntity',
      pos: Context.currentPos(),
      access: [APublic],
      kind: FFun({
        args: [{
          name: 'entity',
          meta: null,
          opt: false,
          value: null,
          type: TPath({
            name: 'Entity',
            pack: ['phi'],
            params: null,
            sub: null
          })
        }],
        ret: TPath({
          name: 'Void',
          pack: [],
          params: null,
          sub: null
        }),
        expr: macro {
          if (entities.exists(entity)) {
            onUnmatched(entities.get(entity), entity);
            entities.remove(entity);
          }
        },
        params: null
      })
    }
  }

  private static function getTypeId (field: Field): Int {
    return switch(field.kind) {
      case FVar(t, e): getTypeIdOfType(t);
      default: null;
    }
  }

  private static function getTypeIdOfType (ct: ComplexType): Int {
    return switch(ct) {
      case TPath(p): Trait.getTypeId(p.name);
      default:  null;
    }
  }
}

#end