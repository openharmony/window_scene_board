/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveActionButtonVm } from '../../../../../../main/ets/live/vm/LiveActionButtonVm';

export default function LiveActionButtonVmTest() {
  describe('handleTouchEvent_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    handleTouchEventTest1();
    handleTouchEventTest2();
    handleTouchEventTest3();
    handleTouchEventTest4();
    handleTouchEventTest5();
    handleTouchEventTest6();
    handleTouchEventTest7();
    handleTouchEventTest8();
    handleTouchEventTest9();
    handleTouchEventTest10();
    handleTouchEventTest11();
    handleTouchEventTest12();
    handleTouchEventTest13();
    handleTouchEventTest14();
    handleTouchEventTest15();
    handleTouchEventTest16();
    handleTouchEventTest17();
    handleTouchEventTest18();
    handleTouchEventTest19();
    handleTouchEventTest20();
    handleTouchEventTest21();
    handleTouchEventTest22();
    handleTouchEventTest23();
    handleTouchEventTest24();
    handleTouchEventTest25();
    handleTouchEventTest26();
    handleTouchEventTest27();
    handleTouchEventTest28();
    handleTouchEventTest29();
    handleTouchEventTest30();
    handleTouchEventTest31();
    handleTouchEventTest33();
    handleTouchEventTest34();
    handleTouchEventTest35();
    handleTouchEventTest36();
    handleTouchEventTest37();
    handleTouchEventTest38();
    handleTouchEventTest39();
    handleTouchEventTest40();
    handleTouchEventTest41();
    handleTouchEventTest42();
    handleTouchEventTest43();
    handleTouchEventTest44();
    handleTouchEventTest45();
    handleTouchEventTest46();
    handleTouchEventTest47();
    handleTouchEventTest48();
    handleTouchEventTest49();
    handleTouchEventTest50();
    handleTouchEventTest51();
    handleTouchEventTest52();
    handleTouchEventTest53();
    handleTouchEventTest54();
    handleTouchEventTest55();
    handleTouchEventTest56();
    handleTouchEventTest57();
    handleTouchEventTest58();
    handleTouchEventTest59();
    handleTouchEventTest60();
    handleTouchEventTest61();
    handleTouchEventTest62();
    handleTouchEventTest63();
    handleTouchEventTest64();
  });

  describe('onUpdate_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    onUpdateTest1();
    onUpdateTest2();
  });
}

function handleTouchEventTest1() {
  it('should_set_backgroundColors_when_event_type_is_Down', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest2() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}

function handleTouchEventTest3() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}

function handleTouchEventTest4() {
  it('should_reset_backgroundColors_when_event_type_is_Up', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}

function handleTouchEventTest5() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 100,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest6() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_100_area_height_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest7() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_100_globalY_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 100, y: 100
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest8() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_100_positionY_is_100', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
      let touchObj: TouchObject = {
        type: TouchType.Move,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: -1,
        y: -1,
      }
      let position: Position = {
        x: 100, y: 100
      };
      let globalPosition: Position = {
        x: 0, y: 0
      };
      let area: Area = {
        width: 0,
        height: 0,
        position: position,
        globalPosition: globalPosition,
      }
      let event: TouchEvent = {
        type: TouchType.Move,
        touches: [touchObj],
        changedTouches: [touchObj],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [];
        },
        preventDefault: () => {
        },
        target: {
          area: area,
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
      buttonVm.handleTouchEvent(event, 0);
      expect(buttonVm.backgroundColors.length).assertEqual(0);
    });
}
function handleTouchEventTest9() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_100_globalPositionY_is_100', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
      let touchObj: TouchObject = {
        type: TouchType.Move,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: -1,
        y: -1,
      }
      let position: Position = {
        x: 0, y: 0
      };
      let globalPosition: Position = {
        x: 100, y: 100
      };
      let area: Area = {
        width: 0,
        height: 0,
        position: position,
        globalPosition: globalPosition,
      }
      let event: TouchEvent = {
        type: TouchType.Move,
        touches: [touchObj],
        changedTouches: [touchObj],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [];
        },
        preventDefault: () => {
        },
        target: {
          area: area,
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
      buttonVm.handleTouchEvent(event, 0);
      expect(buttonVm.backgroundColors.length).assertEqual(0);
    });
}
function handleTouchEventTest10() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_100_positionY_is_100', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
      let touchObj: TouchObject = {
        type: TouchType.Move,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }
      let position: Position = {
        x: 100, y: 100
      };
      let globalPosition: Position = {
        x: 0, y: 0
      };
      let area: Area = {
        width: 0,
        height: 0,
        position: position,
        globalPosition: globalPosition,
      }
      let event: TouchEvent = {
        type: TouchType.Move,
        touches: [touchObj],
        changedTouches: [touchObj],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [];
        },
        preventDefault: () => {
        },
        target: {
          area: area,
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
      buttonVm.handleTouchEvent(event, 0);
      expect(buttonVm.backgroundColors.length).assertEqual(1);
    });
}
function handleTouchEventTest11() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_100_globalPositionY_is_100', 0, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      let live: LiveNotification = new LiveNotification();
      let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
      let touchObj: TouchObject = {
        type: TouchType.Move,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }
      let position: Position = {
        x: 0, y: 0
      };
      let globalPosition: Position = {
        x: 100, y: 100
      };
      let area: Area = {
        width: 0,
        height: 0,
        position: position,
        globalPosition: globalPosition,
      }
      let event: TouchEvent = {
        type: TouchType.Move,
        touches: [touchObj],
        changedTouches: [touchObj],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [];
        },
        preventDefault: () => {
        },
        target: {
          area: area,
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
      buttonVm.handleTouchEvent(event, 0);
      expect(buttonVm.backgroundColors.length).assertEqual(1);
    });
}
function handleTouchEventTest12() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_100_positionY_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 100, y: 100
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest13() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_100_globalPositionY_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 100, y: 100
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}

function handleTouchEventTest14() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 200,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest15() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_200_area_height_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 200,
      height: 200,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest16() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_200_globalY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 200, y: 200
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest17() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_200_positionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 200, y: 200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest18() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_200_globalPositionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 200, y: 200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest19() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_200_positionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 200, y: 200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest20() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_200_globalPositionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 200, y: 200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest21() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_200_positionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 200, y: 200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest22() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_200_globalPositionY_is_200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: 200, y: 200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest23() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: -200,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest24() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_-200_area_height_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: -200,
      height: -200,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest25() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_-200_globalY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -200, y: -200
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest26() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_-200_positionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: -200, y: -200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest27() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_-200_globalPositionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -200, y: -200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest28() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_-200_positionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -200, y: -200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest29() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_-200_globalPositionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -200, y: -200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest30() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_-200_positionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -200, y: -200
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest31() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_-200_globalPositionY_is_-200', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -200, y: -200
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest32() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: -300,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest33() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_-300_area_height_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: -300,
      height: -300,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest34() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_-300_globalY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest35() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest36() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest37() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest38() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest39() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest40() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest41() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: -300,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest42() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_-300_area_height_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: -300,
      height: -300,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest43() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_-300_globalY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest44() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest45() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest46() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest47() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest48() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest49() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest50() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: -300,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest51() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_-300_area_height_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: -300,
      height: -300,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest52() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_-300_globalY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest53() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest54() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest55() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest56() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest57() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest58() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest59() {
  it('should_reset_backgroundColors_when_event_type_is_down_id_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: -300,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest60() {
  it('should_reset_backgroundColors_when_event_type_is_down_area_weight_is_-300_area_height_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: -300,
      height: -300,
      position: position,
      globalPosition: position,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}

function handleTouchEventTest61() {
  it('should_reset_backgroundColors_when_event_type_is_down_globalX_is_-300_globalY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 100,
      height: 100,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Down,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors[0]).assertEqual($r('sys.color.ohos_id_color_hover'));
  });
}
function handleTouchEventTest62() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest63() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_false_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: -1,
      y: -1,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest64() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest65() {
  it('should_reset_backgroundColors_when_event_type_is_Move_and_isTouchInArea_is_true_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Move,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Move,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(1);
  });
}
function handleTouchEventTest66() {
  it('should_reset_backgroundColors_when_event_type_is_Up_positionX_is_-300_positionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: -300, y: -300
    };
    let globalPosition: Position = {
      x: 0, y: 0
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function handleTouchEventTest67() {
  it('should_reset_backgroundColors_when_event_type_is_Up_globalPositionX_is_-300_globalPositionY_is_-300', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);
    let touchObj: TouchObject = {
      type: TouchType.Up,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
    }
    let position: Position = {
      x: 0, y: 0
    };
    let globalPosition: Position = {
      x: -300, y: -300
    };
    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: globalPosition,
    }
    let event: TouchEvent = {
      type: TouchType.Up,
      touches: [touchObj],
      changedTouches: [touchObj],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [];
      },
      preventDefault: () => {
      },
      target: {
        area: area,
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    buttonVm.backgroundColors = [$r('sys.color.ohos_id_color_hover')];
    buttonVm.handleTouchEvent(event, 0);
    expect(buttonVm.backgroundColors.length).assertEqual(0);
  });
}
function onUpdateTest1() {
  it('should_update_live_notification_when_live_is_different', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live1: LiveNotification = new LiveNotification();
    let live2: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live1);

    buttonVm.onUpdate(live2);

    expect(buttonVm.live).assertEqual(live2);
  });
}

function onUpdateTest2() {
  it('should_not_update_live_notification_when_live_is_not_different', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let buttonVm: LiveActionButtonVm = new LiveActionButtonVm(liveVmInjector, live);

    expect(buttonVm.live).assertEqual(live);
  });
}