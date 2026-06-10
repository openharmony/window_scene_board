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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level,
  MockKit,
  when,
  ArgumentMatchers} from '@ohos/hypium'
import { GesturePolicy } from '../../../../../main/ets/gesture/GesturePolicy'
import { UIContext } from '@kit.ArkUI'
import {
  ExecuteCallbackExtraInfo,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty, SCBSystemSceneSession, ScenePanelState } from '@ohos/windowscene'
import { IFreeWindowsViewModel,
  SCBFreeWindowsViewModelManager,
  SCBScenePanelProxy, ViewModelType } from '../../../../../../Index'
import { TouchGestureAction, TouchGestureEvent } from '@ohos.multimodalInput.gestureEvent'
import sceneSessionManager from '@ohos.sceneSessionManager'
import { IGesturePolicy } from '../../../../../main/ets/gesture/IGesturePolicy'
import { ReflectionUtils } from '../ReflectionUtils'

let testUiContext: UIContext = new UIContext();
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let testPanelProxy: SCBScenePanelProxy;
let padFreeWindowsViewModel: IFreeWindowsViewModel;
let freeWindowsViewModelManager: SCBFreeWindowsViewModelManager;
let touchGestureEvent: TouchGestureEvent;
let sceneInfo: SCBSceneInfo;
let session: SCBSceneSession;
let gesturePolicy: IGesturePolicy;

export function GesturePolicyTest() {
  describe('GesturePolicyTest', () => {
    beforeAll((): void => {
      testUiContext = new UIContext();
      screenProperty.screenId = 100;
      screenProperty.width = 3296;
      screenProperty.height = 2472;
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
      touchGestureEvent = {
        action: TouchGestureAction.PINCH_OPENED,
        touches: [],
      };

      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 1);
      session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      session.sessionData.isDragging = true;
      freeWindowsViewModelManager = new SCBFreeWindowsViewModelManager();
      padFreeWindowsViewModel = freeWindowsViewModelManager.getOrCreatePresenter(
        testUiContext, screenProperty, testPanelProxy, ViewModelType.VIEW_MODEL_PC);
      gesturePolicy = new GesturePolicy(padFreeWindowsViewModel);
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('handlePinchGestureTest', 0, (): void => {
      let ret: boolean = ReflectionUtils.useFunc(gesturePolicy, 'handlePinchGesture', touchGestureEvent);
      expect(ret).assertFalse();
    })
  })
}
