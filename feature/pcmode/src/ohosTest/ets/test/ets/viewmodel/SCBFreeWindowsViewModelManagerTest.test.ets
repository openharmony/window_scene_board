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

import { beforeAll, beforeEach, describe, expect, it, Level } from "@ohos/hypium";
import { SCBFreeWindowsViewModelManager, SCBScenePanelProxy, ViewModelType } from "../../../../../../Index";
import { UIContext } from "@kit.ArkUI";
import {
  ExecuteCallbackExtraInfo,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSystemSceneSession,
  ScenePanelState } from "@ohos/windowscene";
import { SCBPcFreeWindowsViewModel } from "../../../../../main/ets/presenter/SCBPcFreeWindowsViewModel";

let freeWindowsViewModelManager: SCBFreeWindowsViewModelManager;
let testUiContext: UIContext;
let testPanelProxy: SCBScenePanelProxy;
let screenProperty: SCBScreenProperty;
export function SCBFreeWindowsViewModelManagerTest() {
  describe('SCBFreeWindowsViewModelManagerTest', () => {
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
      screenProperty = new SCBScreenProperty();
      screenProperty.screenId = 100;
    });
    beforeEach(() => {
      freeWindowsViewModelManager = new SCBFreeWindowsViewModelManager();
    });
    getOrCreatePresenterTest();
    getPresenterTest();
    removePresenterTest();
  });
}

function getOrCreatePresenterTest() {
  it('getOrCreatePresenterTest_02', Level.LEVEL0, () => {
    let viewModel = freeWindowsViewModelManager.getOrCreatePresenter(
      testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PC);
    expect(viewModel instanceof SCBPcFreeWindowsViewModel).assertTrue();
    let viewModel2 = freeWindowsViewModelManager.getOrCreatePresenter(
      testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PC);
    expect(viewModel === viewModel2).assertTrue();
  });
}

function getPresenterTest() {
  it('getPresenterTest_01', Level.LEVEL0, () => {
    let viewModel = freeWindowsViewModelManager.getPresenter(100);
    expect(viewModel).assertNull();
  });
  it('getPresenterTest_02', Level.LEVEL0, () => {
    let viewModel = freeWindowsViewModelManager.getOrCreatePresenter(
      testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PAD);
    let viewModel2 = freeWindowsViewModelManager.getPresenter(100);
    expect(viewModel === viewModel2).assertTrue();
  });
}

function removePresenterTest() {
  it('removePresenterTest_01', Level.LEVEL0, () => {
    let viewModel = freeWindowsViewModelManager.getOrCreatePresenter(
      testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PAD);
    let viewModel2 = freeWindowsViewModelManager.getPresenter(100);
    expect(viewModel2 === viewModel).assertTrue();

    freeWindowsViewModelManager.removePresenter(100);
    let viewModel3 = freeWindowsViewModelManager.getPresenter(100);
    expect(viewModel3 !== viewModel).assertTrue();
  });
}