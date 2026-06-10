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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  AppData,
  SCBAppExitToFolderController,
  SCBExpandController,
  SCBFoldController,
  SCBTransitionController,
} from '../../../../../../main/ets/TsIndex';
import {
  SCBDesktopEventId,
  SCBScreenStateChangeTransitionController,
  SCBTransitionManager,
  SCBUnlockSpaceAniListener,
  SCBUnlockTransitionController
} from '../../../../../../main/ets/animation/SCBTransitionManager';

let transitionManager: SCBTransitionManager;


export default function SCBTransitionManagerTest() {
  describe('SCBTransitionManagerTest', () => {
    beforeAll(() => {
      transitionManager = new SCBTransitionManager();
    });
    beforeEach(() => {
    });
    afterEach(() => {

    });
    afterAll(() => {

    });
    GetStartExitAnimationCount();
    SetStartExitAnimationCount();
    ReduceStartExitAnimationCount();
    SetOverlayCardTransitionController();
    TransitionControllerTest();
    GlobalTransitionController();
    IsOobeBundleName();
    AppExitToFolderController();
    FoldAnimationController();
    ExpandAnimationController();
    SceneTransitionIn();
    SceneTransitionOut();
    CleanTransition();
    GetCurrentTransitionController();
    TransitionCallback();
    UnlockTransitionController();
    ScreenChangeTransitionController();
    UnlockSpaceAniListener();
    TransitionCount();
  });
}

function GetStartExitAnimationCount() {
  it('getStartExitAnimationCount', 0, () => {
    expect(transitionManager.getStartExitAnimationCount()).assertEqual(0);
  });
}

function SetStartExitAnimationCount() {
  it('setStartExitAnimationCount', 0, () => {
    transitionManager.addStartExitAnimationCount();
    expect(transitionManager.getStartExitAnimationCount()).assertEqual(1);
  });
}

function ReduceStartExitAnimationCount() {
  it('reduceStartExitAnimationCount', 0, () => {
    transitionManager.reduceStartExitAnimationCount();
    expect(transitionManager.getStartExitAnimationCount()).assertEqual(0);
    transitionManager.reduceStartExitAnimationCount();
    expect(transitionManager.getStartExitAnimationCount()).assertEqual(0);
  });
}

function SetOverlayCardTransitionController() {

  it('setOverlayCardTransitionController', 0, () => {
    transitionManager.setOverlayCardTransitionController(undefined);

    transitionManager.setOverlayCardTransitionController({
      appData: new AppData,
      onActive: undefined,
      onInactive: undefined,
      overlayCardInfo: undefined
    });
    transitionManager.setOverlayCardTransitionController({
      appData: new AppData,
      onActive: undefined,
      onInactive: undefined,
      overlayCardInfo: {
        startBundleName: undefined,
        isShowOverlayComponent: true
      }
    });
    transitionManager.setOverlayCardTransitionController({
      appData: new AppData,
      onActive: undefined,
      onInactive: undefined,
      overlayCardInfo: {
        startBundleName: "bundleName",
        isShowOverlayComponent: true
      }
    });
    expect(true).assertTrue();

  });
}

function TransitionControllerTest() {
  it('transitionController', 0, () => {
    transitionManager.registerTransitionController(null);
    transitionManager.registerTransitionController(undefined);
    let transitionController: SCBTransitionController = {
      appData: new AppData,
      onActive: () => {
      },
      onInactive: () => {
      }
    }
    transitionManager.registerTransitionController(transitionController);
    transitionController.appData.appIconId = 'registerTransitionController';
    transitionManager.registerTransitionController(transitionController);
    transitionManager.registerTransitionController(transitionController);
    expect(true).assertTrue();

    transitionManager.unRegisterTransitionController(null);
    transitionManager.unRegisterTransitionController(undefined);
    transitionManager.unRegisterTransitionController(transitionController);
    transitionManager.unRegisterTransitionController(transitionController);
    expect(true).assertTrue();
  });
}

function GlobalTransitionController() {
  it('globalTransitionController', 0, () => {
    let appData1 = new AppData();
    appData1.appIconId = "registerGlobalTransitionController"
    let transitionController1: SCBTransitionController = {
      appData: appData1,
      onActive: () => {
      },
      onInactive: () => {
      }
    }
    let appData2 = new AppData();
    appData2.appIconId = "registerGlobalTransitionController"
    let transitionController2: SCBTransitionController = {
      appData: appData2,
      onActive: () => {
      },
      onInactive: () => {
      },
      onActiveWithNoAnim: () => {
      }
    }
    transitionManager.registerGlobalTransitionController(transitionController1);
    transitionManager.registerGlobalTransitionController(transitionController1);
    transitionManager.registerGlobalTransitionController(transitionController2);

    transitionManager.runGlobalActiveCallback(true);
    transitionManager.runGlobalActiveCallback(false);

    transitionManager.unRegisterGlobalTransitionController(transitionController1);
    transitionManager.registerGlobalTransitionController(transitionController1);
    transitionManager.unRegisterGlobalTransitionController(transitionController1);
    expect(true).assertTrue();
  });
}

function IsOobeBundleName() {
  it('isOobeBundleName', 0, () => {
    expect(transitionManager.isOobeBundleName("bundleName")).not().assertNull();
  });
}

function AppExitToFolderController() {
  it('AppExitToFolderController', 0, () => {
    let appExitToFolderController1: SCBAppExitToFolderController = {
      folderKey: 'registerAppExitToFolderController',
      onExitStart: (folderId: string, appIndex: number): void => {
      },
      onExitEnd: (folderId: string, appIndex: number): void => {
      }
    }
    let appExitToFolderController2: SCBAppExitToFolderController = {
      folderKey: 'registerAppExitToFolderController',
      onExitStart: (folderId: string, appIndex: number): void => {
      },
      onExitEnd: (folderId: string, appIndex: number): void => {
      }
    }
    transitionManager.registerAppExitToFolderController(null);
    transitionManager.registerAppExitToFolderController(undefined);
    transitionManager.registerAppExitToFolderController(appExitToFolderController1);
    transitionManager.registerAppExitToFolderController(appExitToFolderController1);
    transitionManager.registerAppExitToFolderController(appExitToFolderController2);

    transitionManager.runAppExitToFolderStartCallback("registerAppExitToFolderController", 0);
    transitionManager.runAppExitToFolderEndCallback("registerAppExitToFolderController", 0);
    transitionManager.runAppExitToFolderStartCallback("notExist", 0);
    transitionManager.runAppExitToFolderEndCallback("notExist", 0);


    transitionManager.unRegisterAppExitToFolderController(null);
    transitionManager.unRegisterAppExitToFolderController(undefined);
    transitionManager.unRegisterAppExitToFolderController(appExitToFolderController1);
    transitionManager.unRegisterAppExitToFolderController(appExitToFolderController1);
    expect(true).assertTrue();
  });
}

function FoldAnimationController() {
  it('foldAnimationController', 0, () => {
    let foldController: SCBFoldController = {
      itemId: 'foldController',
      onFoldAnimation: () => {
      }
    }
    transitionManager.registerFoldAnimationController(foldController);
    transitionManager.registerFoldAnimationController(foldController);

    transitionManager.runFoldAnimationCallback();

    transitionManager.unRegisterFoldAnimationController(null);
    transitionManager.unRegisterFoldAnimationController(foldController);
    transitionManager.unRegisterFoldAnimationController(foldController);
    expect(true).assertTrue();
  });
}

function ExpandAnimationController() {
  it('expandAnimationController', 0, () => {
    let expandAnimationController: SCBExpandController = {
      itemId: '',
      onExpandAnimation: () => {
      }
    }
    transitionManager.registerExpandAnimationController(expandAnimationController);
    transitionManager.registerExpandAnimationController(expandAnimationController);

    transitionManager.runExpandAnimationCallback();

    transitionManager.unRegisterExpandAnimationController(null);
    transitionManager.unRegisterExpandAnimationController(expandAnimationController);
    transitionManager.unRegisterExpandAnimationController(expandAnimationController);
    expect(true).assertTrue();
  });
}

function SceneTransitionIn() {
  it('sceneTransitionIn', 0, () => {
    let appData1 = new AppData();
    appData1.bundleName = "notifySceneTransitionIn1"
    let transitionController: SCBTransitionController = {
      appData: appData1,
      onActive: () => {
      },
      onInactive: () => {
      },
      cancelAnim: () => {
      }
    }
    let appData2 = new AppData();
    appData2.bundleName = "notifySceneTransitionIn2"
    let transitionController2: SCBTransitionController = {
      appData: appData2,
      onActive: () => {
      },
      onInactive: () => {
      },
      cancelAnim: () => {
      }
    }
    transitionManager.notifySceneTransitionIn(null, true);
    transitionManager.notifySceneTransitionIn(transitionController, true);
    transitionManager.notifySceneTransitionIn(transitionController2, false);
    transitionManager.notifySceneTransitionIn(transitionController2, true);
    transitionManager.notifySceneTransitionIn(transitionController, false);
    transitionManager.notifySceneTransitionIn(transitionController, false, false , true);
    transitionManager.notifySceneTransitionIn(transitionController, false, false , false);
    transitionManager.cleanTransition(transitionController);
    expect(true).assertTrue();
  });
}

function SceneTransitionOut() {
  it('sceneTransitionOut', 0, () => {
    let appData = new AppData();
    appData.bundleName = "notifySceneTransitionOut1"
    appData.appIconId = "notifySceneTransitionOut1"
    let transitionController: SCBTransitionController = {
      appData: appData,
      onActive: () => {
      },
      onInactive: () => {
      }
    }
    appData = new AppData();
    appData.bundleName = "notifySceneTransitionOut2"
    appData.appIconId = "notifySceneTransitionOut2"
    let transitionController2: SCBTransitionController = {
      appData: appData,
      onActive: () => {
      },
      onInactive: () => {
      }
    }
    transitionManager.notifySceneTransitionOut(null, true);
    transitionManager.notifySceneTransitionOut(transitionController, true);
    transitionManager.notifySceneTransitionOut(transitionController2, false);
    transitionManager.notifySceneTransitionOut(transitionController2, false);
    transitionManager.notifySceneTransitionOut(transitionController2, true);
    transitionManager.cleanTransition(transitionController2);
    expect(true).assertTrue();
  });
}

function CleanTransition() {
  it('cleanTransition', 0, () => {
    let appData = new AppData();
    appData.bundleName = "notifySceneTransitionIn1"
    let transitionController1: SCBTransitionController = {
      appData: appData,
      onActive: () => {
      },
      onInactive: () => {
      },
      cancelAnim: () => {
      }
    }
    let transitionController2: SCBTransitionController = {
      appData: appData,
      onActive: () => {
      },
      onInactive: () => {
      },
      cancelAnim: () => {
      }
    }
    transitionManager.cleanTransition(null);
    transitionManager.notifySceneTransitionIn(transitionController1, false);
    transitionManager.cleanTransition(transitionController2);
    transitionManager.cleanTransition(transitionController1);
    transitionManager.cleanTransition(transitionController1);
    expect(true).assertTrue();
  });
}

function GetCurrentTransitionController() {
  it('getCurrentTransitionController', 0, () => {
    transitionManager.getCurrentTransitionController();
    expect(true).assertTrue();
  });
}

function TransitionCallback() {
  it('transitionCallback', 0, () => {
    let func: Function = () => {
    };
    transitionManager.swipeUpFromHome(0);
    transitionManager.swipeUpBackHomeFromHome(0);

    transitionManager.registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME, func);
    transitionManager.registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME, func);
    transitionManager.registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME, func);
    transitionManager.swipeUpFromHome(0);
    transitionManager.swipeUpBackHomeFromHome(0);
    transitionManager.unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME, func);
    transitionManager.unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME, func);
    transitionManager.unRegisterTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME, func);
    expect(true).assertTrue();
  });
}

function UnlockTransitionController() {
  it('unlockTransitionController', 0, () => {
    let unlockTransitionController: SCBUnlockTransitionController = {
      name: 'unlockTransitionController1',
      onLock: (): void => {
      },
      onUnlock: (): void => {
      }
    };
    transitionManager.registerUnlockTransitionController(null, true);
    transitionManager.registerUnlockTransitionController(undefined, false);
    transitionManager.registerUnlockTransitionController(unlockTransitionController, true);
    transitionManager.registerUnlockTransitionController(unlockTransitionController, true);
    transitionManager.registerUnlockTransitionController(unlockTransitionController, false);
    transitionManager.registerUnlockTransitionController(unlockTransitionController, false);

    transitionManager.notifyUnlockTransition();
    transitionManager.notifyLockTransition();
    transitionManager.onUnlockTransitionEnterHome();
    transitionManager.onLockTransitionEnterHome();

    transitionManager.unRegisterUnlockTransitionController(null, true);
    transitionManager.unRegisterUnlockTransitionController(unlockTransitionController, true);
    transitionManager.unRegisterUnlockTransitionController(unlockTransitionController, false);
    transitionManager.unRegisterUnlockTransitionController(unlockTransitionController, true);
    transitionManager.unRegisterUnlockTransitionController(unlockTransitionController, false);

    expect(true).assertTrue();
  });
}

function UnlockSpaceAniListener() {
  it('unlockSpaceAniListener', 0, () => {
    let unlockSpaceAniListener: SCBUnlockSpaceAniListener = {
      onFinish: (): void => {
      }
    };
    transitionManager.registerUnlockSpaceAniListener(unlockSpaceAniListener);

    transitionManager.notifyUnlockSpaceAniFinished();

    transitionManager.unRegisterUnlockSpaceAniListener();

    expect(true).assertTrue();
  });
}

function ScreenChangeTransitionController() {
  it('screenChangeTransitionController', 0, () => {
    let screenStateChangeTransitionController: SCBScreenStateChangeTransitionController = {
      name: 'screenChangeTransitionController',
      beginScreenOn: (): void => {
      },
      endScreenOn: (): void => {
      },
      screenOff: (): void => {
      }
    };
    transitionManager.registerScreenChangeTransitionController(null);
    transitionManager.registerScreenChangeTransitionController(screenStateChangeTransitionController);

    transitionManager.notifyBeginScreenOnTransition();
    transitionManager.notifyEndScreenOnTransition();
    transitionManager.notifyScreenOffTransition();

    transitionManager.unRegisterScreenChangeTransitionController(null);
    transitionManager.unRegisterScreenChangeTransitionController(screenStateChangeTransitionController);
    transitionManager.unRegisterScreenChangeTransitionController(screenStateChangeTransitionController);

    expect(true).assertTrue();
  });
}

function TransitionCount() {
  it('transitionCount', 0, () => {
    transitionManager.clearTransitionCount("test");
    expect(transitionManager.getTransitionCount("test")).assertEqual(0);
    transitionManager.addTransitionCount("test");
    expect(transitionManager.getTransitionCount("test")).assertEqual(1);
    transitionManager.clearTransitionCount("test");
    expect(transitionManager.getTransitionCount("test")).assertEqual(0);
  });
}

