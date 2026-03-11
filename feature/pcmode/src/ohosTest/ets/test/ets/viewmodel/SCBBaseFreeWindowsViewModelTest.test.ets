/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { afterAll, beforeAll, beforeEach, describe, expect, it, Level } from "@ohos/hypium";
import {
  ExecuteCallbackExtraInfo,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMemoryInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSystemSceneSession,
  ScenePanelState
} from "@ohos/windowscene";
import {
  IFreeWindowsViewModel,
  PcSCBSceneContainerSessionArray,
  PolicyType,
  RealScreenInfo,
  SCBFreeWindowsViewModelManager,
  SCBScenePanelProxy,
  ViewModelType
} from "../../../../../../Index";
import { UIContext } from "@kit.ArkUI";
import { ILayoutPolicy } from "../../../../../main/ets/layout/ILayoutPolicy";
import { ILifecyclePolicy } from "../../../../../main/ets/lifecycle/ILifecyclePolicy";
import { LayoutPolicy } from "../../../../../main/ets/layout/LayoutPolicy";
import { LifecyclePolicy } from "../../../../../main/ets/lifecycle/LifecyclePolicy";
import { SceneAnimationPolicy } from "../../../../../main/ets/animation/SceneAnimationPolicy";
import { IAnimationPolicy } from "../../../../../main/ets/animation/IAnimationPolicy";
import { ReflectionUtils } from "../ReflectionUtils";
import sceneSessionManager from "@ohos.sceneSessionManager";

let freeWindowsViewModelManager: SCBFreeWindowsViewModelManager;
let testUiContext: UIContext;
let testPanelProxy: SCBScenePanelProxy;
let padFreeWindowsViewModel: IFreeWindowsViewModel;
let screenProperty: SCBScreenProperty;
let persistentIds: number[] = [];
let notShowPersistentIds: number[] = [];

export function SCBBaseFreeWindowsViewModelTest() {
  describe('SCBBaseFreeWindowsViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      testUiContext = new UIContext();
      testPanelProxy = {
        getSysSceneSession: (): SCBSystemSceneSession => {
          throw new Error("Function not implemented.");
        },
        getScroller: (): Scroller => {
          throw new Error("Function not implemented.");
        },
        getScenePanelState: (): ScenePanelState => {
          throw new Error("Function not implemented.");
        },
        updateScenePanelState: (state: ScenePanelState): void => {
          throw new Error("Function not implemented.");
        },
        setIsPairSplit: (isPairSplit: boolean): void => {
          throw new Error("Function not implemented.");
        },
        getScreenDpiDensity: (): number => {
          throw new Error("Function not implemented.");
        },
        enterSplitView: (container: SCBSceneContainerSession, isSplitRecentPrimary: boolean): void => {
          throw new Error("Function not implemented.");
        },
        isOpenFromPopup: (): boolean => {
          throw new Error("Function not implemented.");
        },
        getCardWidth: (): number => {
          throw new Error("Function not implemented.");
        },
        getCardPositionX: (): number => {
          throw new Error("Function not implemented.");
        },
        getCardPositionY: (): number => {
          throw new Error("Function not implemented.");
        },
        isRecycleBin: (sceneInfo?: SCBSceneInfo | undefined, extraInfo?: ExecuteCallbackExtraInfo | undefined): boolean => {
          throw new Error("Function not implemented.");
        },
        setRecentDataList: (isNeedHideAppCenter: boolean): void => {
          throw new Error("Function not implemented.");
        },
        exitSplitRecentView: (isAnimateImmediately: boolean, isPairSplit: boolean): void => {
          throw new Error("Function not implemented.");
        },
        exitSplitRecentViewIfNotShowRecent: (): void => {
          throw new Error("Function not implemented.");
        },
        exitRecentWhenStartSceneFromRecent: (container: SCBSceneContainerSession): void => {
          throw new Error("Function not implemented.");
        },
        recentSceneCloseAnimate: (container: SCBSceneContainerSession): void => {
          throw new Error("Function not implemented.");
        },
        updateRecentInfoAfterExitForSplit: (newContainer: SCBSceneContainerSession, curContainer: SCBSceneContainerSession,
          primarySession: SCBSceneSession, secondarySession: SCBSceneSession | null, isEnterPair: boolean): void => {
          throw new Error("Function not implemented.");
        },
        refreshRecentInfo: (): void => {
          throw new Error("Function not implemented.");
        },
        exitRecentView: (needAnim: boolean): void => {
          throw new Error("Function not implemented.");
        },
        exitAppCenterView: (): void => {
          throw new Error("Function not implemented.");
        },
        recentSceneResizeAnimate: (): void => {
          throw new Error("Function not implemented.");
        },
        handleHideCloseInRecent: (containerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
          isFromClient: boolean): void => {
          throw new Error("Function not implemented.");
        },
        recentOrSplitClose: (containerSession: SCBSceneContainerSession, isException?: boolean | undefined,
          isSaveSnapshot?: boolean | undefined, extraInfo?: ExecuteCallbackExtraInfo | undefined): void => {
          throw new Error("Function not implemented.");
        },
        minimizeSceneInRecent: (container: SCBSceneContainerSession): void => {
          throw new Error("Function not implemented.");
        },
        raiseSceneToTopInRecent: (container: SCBSceneContainerSession): void => {
          throw new Error("Function not implemented.");
        },
        setPairPersistentId: (persistentId: number): void => {
          throw new Error("Function not implemented.");
        },
        sessionRectChangeInRecent: (): void => {
          throw new Error("Function not implemented.");
        }
      }
      freeWindowsViewModelManager = new SCBFreeWindowsViewModelManager();
      screenProperty= new SCBScreenProperty();
      screenProperty.screenId = 100;
      screenProperty.width = 1920;
      screenProperty.height = 1080;
      padFreeWindowsViewModel = freeWindowsViewModelManager.getOrCreatePresenter(
        testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PAD);
      padFreeWindowsViewModel.onStart();
      prepareContainerList();
      prepareNotShowContainerList();
    });
    beforeEach(() => {
    });
    afterAll(() => {
      padFreeWindowsViewModel.onDestroy();
    });
    getContainerSessionListTest();
    getContainerSessionListNotShowRecentTest();
    getScreenPropertyTest();
    getPanelProxyTest();
    getSceneContainerSessionWithPersistentIdTest();
    getPolicyTest();
    getRealScreenInfoTest();
    calculateMaxRectTest();
    exceedScreenSizeRecoverMaxTest();
  });
}

function prepareContainerList() {
  let containerList: PcSCBSceneContainerSessionArray =
    Reflect.get(padFreeWindowsViewModel, 'containerSessionList');
  let sceneManager = SCBSceneSessionManager.getInstance();
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(scene, screenProperty);
    containerList.add(container);
    persistentIds.push(testSession.persistentId);
  }
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle2', 'module2', 'ability2');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(scene, screenProperty);
    containerList.add(container);
    persistentIds.push(testSession.persistentId);
  }
}

function prepareNotShowContainerList() {
  let containerList: PcSCBSceneContainerSessionArray =
    Reflect.get(padFreeWindowsViewModel, 'containerSessionListNotShowRecent');
  let sceneManager = SCBSceneSessionManager.getInstance();
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('notShowBundle1',
      'notShowModule1', 'notShowAbility1');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(scene, screenProperty);
    containerList.add(container);
    notShowPersistentIds.push(testSession.persistentId);
  }
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('notShowBundle2',
      'notShowModule2', 'notShowAbility2');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(scene, screenProperty);
    containerList.add(container);
    notShowPersistentIds.push(testSession.persistentId);
  }
}

function getContainerSessionListTest() {
  it('getContainerSessionListTest_01', Level.LEVEL0, () => {
    let containerList: PcSCBSceneContainerSessionArray =
      Reflect.get(padFreeWindowsViewModel, 'containerSessionList');
    let containerList2: PcSCBSceneContainerSessionArray = padFreeWindowsViewModel.getContainerSessionList();
    expect(containerList === containerList2).assertTrue();
  });
}

function getContainerSessionListNotShowRecentTest() {
  it('getContainerSessionListNotShowRecentTest_01', Level.LEVEL0, () => {
    let containerList: SCBSceneContainerSessionArray =
      Reflect.get(padFreeWindowsViewModel, 'containerSessionListNotShowRecent');
    let containerList2: SCBSceneContainerSessionArray =
      padFreeWindowsViewModel.getContainerSessionListNotShowRecent();
    expect(containerList === containerList2).assertTrue();
  });
}

function getScreenPropertyTest() {
  it('getScreenPropertyTest_01', Level.LEVEL0, () => {
    let screenProperty: SCBScreenProperty =
      Reflect.get(padFreeWindowsViewModel, 'screenProperty');
    let screenProperty2: SCBScreenProperty =
      padFreeWindowsViewModel.getScreenProperty();
    expect(screenProperty === screenProperty2).assertTrue();
  });
}

function getPanelProxyTest() {
  it('getPanelProxyTest_01', Level.LEVEL0, () => {
    let panelProxy: SCBScenePanelProxy =
      Reflect.get(padFreeWindowsViewModel, 'panelProxy');
    let panelProxy2: SCBScenePanelProxy =
      padFreeWindowsViewModel.getPanelProxy();
    expect(panelProxy === panelProxy2).assertTrue();
  });
}

function getSceneContainerSessionWithPersistentIdTest() {
  it('getSceneContainerSessionWithPersistentIdTest_01', Level.LEVEL0, () => {
    let container: SCBSceneContainerSession | null =
      padFreeWindowsViewModel.getSceneContainerSessionWithPersistentId(undefined);
    expect(container).assertNull();
  });
  it('getSceneContainerSessionWithPersistentIdTest_02', Level.LEVEL0, () => {
    let container: SCBSceneContainerSession | null =
      padFreeWindowsViewModel.getSceneContainerSessionWithPersistentId(persistentIds[0]);
    expect(container !==null ).assertTrue();
  });
  it('getSceneContainerSessionWithPersistentIdTest_03', Level.LEVEL0, () => {
    let container: SCBSceneContainerSession | null =
      padFreeWindowsViewModel.getSceneContainerSessionWithPersistentId(notShowPersistentIds[0]);
    expect(container !==null ).assertTrue();
  });
  it('getSceneContainerSessionWithPersistentIdTest_04', Level.LEVEL0, () => {
    let container: SCBSceneContainerSession | null =
      padFreeWindowsViewModel.getSceneContainerSessionWithPersistentId(-1);
    expect(container).assertNull();
  });
}

function getPolicyTest() {
  it('getPolicyTest_01', Level.LEVEL0, () => {
    let layoutPolicy: ILayoutPolicy | null =
      padFreeWindowsViewModel.getPolicy<ILayoutPolicy>(PolicyType.POLICY_LAYOUT);
    expect(layoutPolicy instanceof LayoutPolicy).assertTrue();
    let lifecyclePolicy: ILifecyclePolicy | null =
      padFreeWindowsViewModel.getPolicy<ILifecyclePolicy>(PolicyType.POLICY_LIFECYCLE);
    expect(lifecyclePolicy instanceof LifecyclePolicy).assertTrue();
    let animationPolicy: IAnimationPolicy | null =
      padFreeWindowsViewModel.getPolicy<IAnimationPolicy>(PolicyType.POLICY_ANIMATION);
    expect(animationPolicy instanceof SceneAnimationPolicy).assertTrue();
  });
}

function getRealScreenInfoTest() {
  it('getRealScreenInfoTest', Level.LEVEL0, () => {
    let ret: RealScreenInfo = ReflectionUtils.useFunc(padFreeWindowsViewModel, 'getRealScreenInfo', 0);
    expect(ret.maxTop).assertEqual(0);
  });
}

function calculateMaxRectTest() {
  it('calculateMaxRectTest', Level.LEVEL0, () => {
    screenProperty.width = 3296;
    screenProperty.height = 2472;
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let ret: SCBSessionRect = ReflectionUtils.useFunc(padFreeWindowsViewModel, 'calculateMaxRect', session);
    expect(ret.height.getPx()).assertEqual(2472);
    screenProperty.width = 1920;
    screenProperty.height = 1080;
  });
}

function exceedScreenSizeRecoverMaxTest() {
  it('exceedScreenSizeRecoverMaxTest', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    session.layoutFullScreen = true;
    let sceneMemoryInfo: SCBSceneMemoryInfo =
      new SCBSceneMemoryInfo(SCBSceneMode.UNDEFINED, false, false, -1, -1);
    let ret: boolean = ReflectionUtils.useFunc(padFreeWindowsViewModel, 'exceedScreenSizeRecoverMax', session, sceneInfo, sceneMemoryInfo);
    expect(ret).assertFalse();
  });
}