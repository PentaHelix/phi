package traits;

import structureTypes.StructureType;
import phi.Trait;

class HexStructure implements Trait {
  public var structureId: Int;
  public var name: String;
  public var type: StructureType;
  public var state: Int;

  private var states: Array<String>;

  public function new (name: String, type: StructureType) {
    this.name = name;
    var data = C.structures.get(name);
    this.structureId = data.id;
    this.type = type;
    type.structure = this;
    this.states = data.states;
    this.state = 0;
  }

  public function setState (name: String) {
    state = states.indexOf(name);
  }
}