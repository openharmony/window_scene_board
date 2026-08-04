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

import {
  describe,
  expect,
  it,
  Level,
  ArgumentMatchers,
  MockKit,
  when
} from '@ohos/hypium';
import {
  DeviceHelper,
  SCBTriFoldManager,
  SCBTripleFoldState,
  ScreenState
} from '@ohos/frameworkwrapper';
import { ReflectionUtils } from '../../WindowScene/utils/ReflectionUtils';
import {
  SCBSceneWindowAiSplitSwitchUtils,
  AiSceneState,
  SwitchType,
  ViewSplitListener
} from '../../../../../../main/ets/scene/utils/SCBSceneWindowAiSplitSwitchUtils';
import { ArrayList } from '@kit.ArkTS';
import { insightIntent } from '@kit.IntentsKit';
import {
  SCBPropertyChangeReason,
  SCBSceneContainerState
} from '../../../../../../main/ets/TsIndex';
import {
  SCBSceneInfo,
  SCBSceneMode
} from '../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBSceneContainerSession } from '../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneSession } from '../../../../../../main/ets/scene/session/SCBSceneSession';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBScreenProperty } from '../../../../../../main/ets/TsIndex';

const NATURAL_WAITING_TIME: number = 3000;
const TIMER_BIAS: number = 100;

// the flag of listener
let flag: boolean = false;

export default function SCBSceneWindowAiSplitSwitchTest() {
  describe('SCBSceneWindowAiSplitSwitchTest', () => {
    getInstanceTest();
    notifyListenerToSplitScreenTest();
    notifyListenerToSetIntentTest();
    addViewSplitListenerTest();
    removeViewSplitListenerTest();
    isTargetSceneTest();
    isNaturalSceneTest();
    isSplitSceneTest();
    startAiSplitSwitchHandlerByContainerTest();
    startAiSplitSwitchHandlerTest();
    endAiSplitSwitchHandlerTest();
    endAiSplitSwitchHandlerByContainerStateTest();
    aiSplitSwitchByStateChangeTest();
    aiSplitSwitchByPropertyChangeTest();
    setSwitchTypeTest();
    getSwitchTypeTest();
    saveNaturalSceneInfoTest();
    aiSplitSwitchBySceneSessionTest();
    startNaturalSwitchSceneTest();
    isNeedToShareIntentAsNaturalSwitchTest();
    setIsSharingIntentTest();
    getIsSharingIntentTest();
  });
}

export function getInstanceTest() {
  it('getInstance_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName');
    expect(result).assertEqual('');
  });

  it('getInstance_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName');
    expect(result).assertEqual('');
  });

  it('getInstance_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName');
    expect(result).assertEqual('');
  });

  it('getInstance_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName');
    expect(result).assertEqual('');
  });

  it('getInstance_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName');
    expect(result).assertEqual('');
  });

  it('getInstance_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: string = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName');
    expect(result).assertEqual('');
  });

  it('getInstance_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: SCBSceneInfo | null = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo');
    expect(result).assertEqual(null);
  });

  it('getInstance_08', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: AiSceneState = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('getInstance_10', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: boolean = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming');
    expect(result).assertEqual(false);
  });

  it('getInstance_11', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: SwitchType = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType');
    expect(result).assertEqual(SwitchType.INVALID);
  });

  it('getInstance_12', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: SCBSceneInfo | null = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo');
    expect(result).assertEqual(null);
  });

  it('getInstance_13', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let result: SCBSceneInfo | null = ReflectionUtils
      .getProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo');
    expect(result).assertEqual(null);
  });
}

export function notifyListenerToSplitScreenTest() {
  it('notifyListenerToSplitScreen_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.INVALID;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(!flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo | null = null;
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.NATURAL_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(!flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo | null = null;
    let switchType: SwitchType = SwitchType.NATURAL_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(!flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.NATURAL_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo | null = null;
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.FREQUENT_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(!flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo | null = null;
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.FREQUENT_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(!flag).assertTrue();
  });

  it('notifyListenerToSplitScreen_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('J', 'K', 'L');
    let switchType: SwitchType = SwitchType.FREQUENT_SWITCH;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppSceneInfo', primaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppSceneInfo', secondaryAppSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo', fromSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo', toSceneInfo);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', switchType);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSplitScreen();
    expect(flag).assertTrue();
  });
}

export function notifyListenerToSetIntentTest() {
  it('notifyListenerToSetIntent_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
        flag = true;
      },
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
      },
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
      }
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.notifyListenerToSetIntent(primaryAppSceneInfo, secondaryAppSceneInfo);
    expect(flag).assertTrue();
  });
}

export function addViewSplitListenerTest() {
  it('addViewSplitListener_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    let resultList: ArrayList<ViewSplitListener> =
      ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList');
    let result: number = resultList.length;
    expect(result).assertEqual(1);
  });

  it('addViewSplitListener_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let secondListener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(secondListener);
    let resultList: ArrayList<ViewSplitListener> =
      ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList');
    let result: number = resultList.length;
    expect(result).assertEqual(2);
  });
}

export function removeViewSplitListenerTest() {
  it('removeViewSplitListener_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let secondListener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(secondListener);
    scbSceneWindowAiSplitSwitchUtils.removeViewSplitListener(listener);
    let resultList: ArrayList<ViewSplitListener> =
      ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList');
    let result: number = resultList.length;
    expect(result).assertEqual(1);
  });

  it('removeViewSplitListener_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let secondListener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(secondListener);
    scbSceneWindowAiSplitSwitchUtils.removeViewSplitListener(secondListener);
    let resultList: ArrayList<ViewSplitListener> =
      ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList');
    let result: number = resultList.length;
    expect(result).assertEqual(1);
  });

  it('removeViewSplitListener_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    let listener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let secondListener: ViewSplitListener = {
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {},
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {},
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {}
    }
    let primaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let secondaryAppSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(secondListener);
    scbSceneWindowAiSplitSwitchUtils.removeViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.removeViewSplitListener(secondListener);
    let resultList: ArrayList<ViewSplitListener> =
      ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList');
    let result: number = resultList.length;
    expect(result).assertEqual(0);
  });
}

export function isTargetSceneTest() {
  it('isTargetScene_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.UNKNOWN);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.UNKNOWN);
    when(isPad)(ArgumentMatchers.any).afterReturn(true);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(result).assertTrue();
  });

  it('isTargetScene_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.UNKNOWN);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.UNKNOWN);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.UNKNOWN);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(result).assertTrue();
  });

  it('isTargetScene_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.M);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.G);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_08', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.F);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_09', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.M);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });

  it('isTargetScene_10', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    let isThreeFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
    let isFoldExpanded: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
    let scbTriFoldManager: SCBTriFoldManager = SCBTriFoldManager.getInstance();
    ReflectionUtils.setProperty(scbTriFoldManager, 'getCurTriFoldState', SCBTripleFoldState.G);
    when(isPad)(ArgumentMatchers.any).afterReturn(false);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isThreeFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isTargetScene();
    expect(!result).assertTrue();
  });
}

export function isNaturalSceneTest() {
  it('isNaturalScene_01', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    fromSceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
    toSceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isNaturalScene(fromSceneInfo, toSceneInfo);
    expect(!result).assertTrue();
  });

  it('isNaturalScene_02', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    fromSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    toSceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isNaturalScene(fromSceneInfo, toSceneInfo);
    expect(!result).assertTrue();
  });

  it('isNaturalScene_03', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    fromSceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
    toSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isNaturalScene(fromSceneInfo, toSceneInfo);
    expect(!result).assertTrue();
  });

  it('isNaturalScene_04', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    fromSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    toSceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isNaturalScene(fromSceneInfo, toSceneInfo);
    expect(result).assertTrue();
  });
}

export function isSplitSceneTest() {
  it('isSplitScene_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(result).assertTrue();
  });

  it('isSplitScene_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });

  it('isSplitScene_08', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.isSplitScene();
    expect(!result).assertTrue();
  });
}

export function startAiSplitSwitchHandlerByContainerTest() {
  it('startAiSplitSwitchHandlerByContainer_01', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let mocker: MockKit = new MockKit();
    let isSupportSplitMode: Function = mocker.mockFunc(sceneSession, sceneSession.isSupportSplitMode);
    when(isSupportSplitMode)(ArgumentMatchers.any).afterReturn(true);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession,
      new SCBScreenProperty());
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    scbSceneWindowAiSplitSwitchUtils.startAiSplitSwitchHandlerByContainer(containerSession);
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName');
    expect(result).assertEqual('A');
  });

  it('startAiSplitSwitchHandlerByContainer_02', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let mocker: MockKit = new MockKit();
    let isSupportSplitMode: Function = mocker.mockFunc(sceneSession, sceneSession.isSupportSplitMode);
    when(isSupportSplitMode)(ArgumentMatchers.any).afterReturn(false);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession,
      new SCBScreenProperty());
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    scbSceneWindowAiSplitSwitchUtils.startAiSplitSwitchHandlerByContainer(containerSession);
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName');
    expect(result).assertEqual('');
  });
}

export function startAiSplitSwitchHandlerTest() {
  it('startAiSplitSwitchHandler_01', Level.LEVEL0, (): void => {
    let appSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let isSupportFloating: boolean = true;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    scbSceneWindowAiSplitSwitchUtils.startAiSplitSwitchHandler(appSceneInfo, isSupportFloating);
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName');
    expect(result).assertEqual('A');
  });

  it('startAiSplitSwitchHandler_02', Level.LEVEL0, (): void => {
    let appSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let isSupportFloating: boolean = true;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    scbSceneWindowAiSplitSwitchUtils.startAiSplitSwitchHandler(appSceneInfo, isSupportFloating);
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName');
    expect(result).assertEqual('B');
  });

  it('startAiSplitSwitchHandler_03', Level.LEVEL0, (): void => {
    let appSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let isSupportFloating: boolean = true;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.INITIAL_STATE);
    scbSceneWindowAiSplitSwitchUtils.startAiSplitSwitchHandler(appSceneInfo, isSupportFloating);
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName');
    expect(result).assertEqual('C');
  });
}

export function endAiSplitSwitchHandlerTest() {
  it('endAiSplitSwitchHandler_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: SwitchType = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType');
    expect(result).assertEqual(SwitchType.INVALID);
  });

  it('endAiSplitSwitchHandler_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: number = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming');
    expect(result).assertTrue();
  });

  it('endAiSplitSwitchHandler_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_08', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: string = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName');
    expect(result).assertEqual('');
  });

  it('endAiSplitSwitchHandler_09', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppBundleName', 'A');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppModuleName', 'B');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'primaryAppAbilityName', 'C');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppBundleName', 'D');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppModuleName', 'E');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'secondaryAppAbilityName', 'F');
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandler();
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });
}

export function endAiSplitSwitchHandlerByContainerStateTest() {
  it('endAiSplitSwitchHandlerByContainerState_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_03', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_04', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_05', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_06', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_07', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('endAiSplitSwitchHandlerByContainerState_08', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_B);
  });

  it('endAiSplitSwitchHandlerByContainerState_09', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_10', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('endAiSplitSwitchHandlerByContainerState_11', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_12', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.HIDDEN;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_13', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('endAiSplitSwitchHandlerByContainerState_14', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_B);
  });

  it('endAiSplitSwitchHandlerByContainerState_15', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', false);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_16', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('endAiSplitSwitchHandlerByContainerState_17', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_B);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('endAiSplitSwitchHandlerByContainerState_18', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let containerState: SCBSceneContainerState = SCBSceneContainerState.RECENT;
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.SECOND_A);
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isTiming', true);
    scbSceneWindowAiSplitSwitchUtils.endAiSplitSwitchHandlerByContainerState(containerState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });
}

export function aiSplitSwitchByStateChangeTest() {
  it('aiSplitSwitchByStateChange_01', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.F;
    let newState: ScreenState = ScreenState.F;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_02', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.F;
    let newState: ScreenState = ScreenState.M;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_03', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.F;
    let newState: ScreenState = ScreenState.G;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_04', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.M;
    let newState: ScreenState = ScreenState.F;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('aiSplitSwitchByStateChange_05', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.M;
    let newState: ScreenState = ScreenState.M;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_06', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.M;
    let newState: ScreenState = ScreenState.G;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_07', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.G;
    let newState: ScreenState = ScreenState.F;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('aiSplitSwitchByStateChange_08', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.G;
    let newState: ScreenState = ScreenState.M;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByStateChange_09', Level.LEVEL0, (): void => {
    let oldState: ScreenState = ScreenState.G;
    let newState: ScreenState = ScreenState.G;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByStateChange(oldState, newState);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });
}

export function aiSplitSwitchByPropertyChangeTest() {
  it('aiSplitSwitchByPropertyChange_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.ROTATION;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.CHANGE_MODE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_04', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_05', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_CONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_06', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_DISCONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_07', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_CONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_08', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_09', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_10', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_11', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SUPER_FOLD_STATUS_CHANGE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_12', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(false);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SINGLE_HAND_STATUS_CHANGE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_13', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_14', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.ROTATION;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_15', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.CHANGE_MODE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_16', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_17', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_CONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_18', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_DISCONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_19', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_CONNECT;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_20', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_21', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('aiSplitSwitchByPropertyChange_22', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_23', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SUPER_FOLD_STATUS_CHANGE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });

  it('aiSplitSwitchByPropertyChange_24', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isLargeInFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
    when(isLargeInFoldProduct)(ArgumentMatchers.any).afterReturn(true);
    let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SINGLE_HAND_STATUS_CHANGE;
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    scbSceneWindowAiSplitSwitchUtils.AiSplitSwitchByPropertyChange(reason);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.FIRST_A);
  });
}

export function setSwitchTypeTest() {
  it('setSwitchType_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.INVALID);
    let switchType: SwitchType = SwitchType.FREQUENT_SWITCH;
    scbSceneWindowAiSplitSwitchUtils.setSwitchType(switchType);
    let result: SwitchType = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType');
    expect(result).assertEqual(SwitchType.FREQUENT_SWITCH);
  });

  it('setSwitchType_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.INVALID);
    let switchType: SwitchType = SwitchType.NATURAL_SWITCH;
    scbSceneWindowAiSplitSwitchUtils.setSwitchType(switchType);
    let result: SwitchType = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType');
    expect(result).assertEqual(SwitchType.NATURAL_SWITCH);
  });
}

export function getSwitchTypeTest() {
  it('getSwitchType_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.NATURAL_SWITCH);
    let result: SwitchType = scbSceneWindowAiSplitSwitchUtils.getSwitchType();
    expect(result).assertEqual(SwitchType.NATURAL_SWITCH);
  });

  it('getSwitchType_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'switchType', SwitchType.FREQUENT_SWITCH);
    let result: SwitchType = scbSceneWindowAiSplitSwitchUtils.getSwitchType();
    expect(result).assertEqual(SwitchType.FREQUENT_SWITCH);
  });
}

export function saveNaturalSceneInfoTest() {
  it('saveNaturalSceneInfo_01', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    scbSceneWindowAiSplitSwitchUtils.saveNaturalSceneInfo(fromSceneInfo, toSceneInfo);
    let result: SCBSceneInfo = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'fromSceneInfo');
    expect(result).assertEqual(fromSceneInfo);
  });

  it('saveNaturalSceneInfo_02', Level.LEVEL0, (): void => {
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    scbSceneWindowAiSplitSwitchUtils.saveNaturalSceneInfo(fromSceneInfo, toSceneInfo);
    let result: SCBSceneInfo = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'toSceneInfo');
    expect(result).assertEqual(toSceneInfo);
  });
}

export function aiSplitSwitchBySceneSessionTest() {
  it('aiSplitSwitchBySceneSession_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    when(isPad)(ArgumentMatchers.any).afterReturn(true);
    let windowMode: SCBSceneMode = SCBSceneMode.UNDEFINED;
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    let isSupportFloating: boolean = true;
    scbSceneWindowAiSplitSwitchUtils.aiSplitSwitchBySceneSession(windowMode, sceneInfo, isSupportFloating);
    let result: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    expect(result).assertEqual(AiSceneState.INITIAL_STATE);
  });

  it('aiSplitSwitchBySceneSession_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    when(isPad)(ArgumentMatchers.any).afterReturn(true);
    let windowMode: SCBSceneMode = SCBSceneMode.FULLSCREEN;
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState', AiSceneState.FIRST_A);
    let isSupportFloating: boolean = true;
    scbSceneWindowAiSplitSwitchUtils.aiSplitSwitchBySceneSession(windowMode, sceneInfo, isSupportFloating);
    let state: AiSceneState = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'aiSceneState');
    let result: boolean = (state === AiSceneState.INITIAL_STATE);
    expect(!result).assertTrue();
  });
}

export function startNaturalSwitchSceneTest() {
  it('startNaturalSwitchScene_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'viewSplitListenerList', viewSplitListenerList);
    flag = false;
    let listener: ViewSplitListener = {
      setSplitIntentByNaturalSwitch: (fromSceneInfo, toSceneInfo) => {
        flag = true;
      },
      setSplitIntentByFrequentSwitch: (primaryAppSceneInfo, secondaryAppSceneInfo) => {
      },
      viewSplitScreen: (primaryAppSceneInfo, secondaryAppSceneInfo, switchType) => {
      }
    }
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    scbSceneWindowAiSplitSwitchUtils.addViewSplitListener(listener);
    scbSceneWindowAiSplitSwitchUtils.startNaturalSwitchScene(fromSceneInfo, toSceneInfo);
    setTimeout(() => {
      expect(flag).assertTrue();
    }, NATURAL_WAITING_TIME + TIMER_BIAS);
  });
}

export function isNeedToShareIntentAsNaturalSwitchTest() {
  it('isNeedToShareIntentAsNaturalSwitch_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let sceneInfo = new SCBSceneInfo('D', 'H', 'I');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession,
      new SCBScreenProperty());
    let result: boolean = scbSceneWindowAiSplitSwitchUtils
      .isNeedToShareIntentAsNaturalSwitch(fromSceneInfo, toSceneInfo, containerSession);
    expect(result).assertTrue();
  });

  it('isNeedToShareIntentAsNaturalSwitch_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('A', 'B', 'C');
    let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('D', 'E', 'F');
    let sceneInfo = new SCBSceneInfo('G', 'H', 'I');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession,
      new SCBScreenProperty());
    let result: boolean = scbSceneWindowAiSplitSwitchUtils
      .isNeedToShareIntentAsNaturalSwitch(fromSceneInfo, toSceneInfo, containerSession);
    expect(!result).assertTrue();
  });
}

export function setIsSharingIntentTest() {
  it('setIsSharingIntent_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent', false);
    let isSharingIntent: boolean = true;
    scbSceneWindowAiSplitSwitchUtils.setIsSharingIntent(isSharingIntent);
    let result: boolean = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent');
    expect(result).assertTrue();
  });

  it('setIsSharingIntent_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent', true);
    let isSharingIntent: boolean = false;
    scbSceneWindowAiSplitSwitchUtils.setIsSharingIntent(isSharingIntent);
    let result: boolean = ReflectionUtils.getProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent');
    expect(!result).assertTrue();
  });
}

export function getIsSharingIntentTest() {
  it('getIsSharingIntent_01', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent', false);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.getIsSharingIntent();
    expect(!result).assertTrue();
  });

  it('getIsSharingIntent_02', Level.LEVEL0, (): void => {
    let scbSceneWindowAiSplitSwitchUtils: SCBSceneWindowAiSplitSwitchUtils =
      SCBSceneWindowAiSplitSwitchUtils.getInstance();
    ReflectionUtils.setProperty(scbSceneWindowAiSplitSwitchUtils, 'isSharingIntent', true);
    let result: boolean = scbSceneWindowAiSplitSwitchUtils.getIsSharingIntent();
    expect(result).assertTrue();
  });
}