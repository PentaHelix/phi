package phi;

import haxe.macro.Context;
import haxe.macro.Expr;

#if !macro
@:autoBuild(phi.Rule.build())
interface Rule<T:{}> {
  public function tick (): Void;
  public function match (e: Entity): Void;
  public function onMatched (e: T): Void;
  public function onUnmatched (e: T): Void;
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

    // add match function
    fields.push(mask(ct));
    fields.push(matcher(ct));
    return fields;
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
              this.entities.set(entity, ${objDecl});
              this.onMatched(${objDecl});
            }
          } else {
            if (this.entities.exists(entity)) {
              this.entities.remove(entity);
              this.onUnmatched(${objDecl});
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
        fields = f;
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
          new phi.Traits($v{fields.map(field ->  getTypeId(field))});
        }
      )
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