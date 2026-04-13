/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EventConstants,
  GlobalContext,
  HiSysBackEventData,
  HiSysEventUtil,
  obtainLocalEvent,
  SCBWindowSceneConfig,
  sEventManager,
  viewMgrPolicy
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { SCBConstants } from '@ohos/commonconstants';
import {
  EventType,
  GestureType,
  PcKeyType,
  ResUtils,
  scbEventExclusiveManager,
  scbGestureManager,
  SCBPropertyChangeReason,
  SCBScenePanelManager,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBUnlockTransitionController,
  ScenePanelState,
} from '@ohos/windowscene';
import { SmallFolderConstants, StyleConstants } from '@ohos/launchercommon';
import FeatureConstants from '@ohos/bigfolder/src/main/ets/default/common/constants/FeatureConstants';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import singletonBackViewModel, {
  SCBGestureBackViewModel
} from '../gesturenavigation/back/viewmodel/SCBGestureBackViewModel';
import { BackEventViewModel } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModel';
import {
  BackEventViewModelCallBack,
  GestureFailReason
} from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModelCallBack';
import { DebugCommandsUtils } from '../gesturenavigation/back/utils/DebugCommandsUtils';
import { BackEventView } from '../gesturenavigation/back/view/BackEventView';
import { PowerStatusEnum, PowerStatusMonitor, PowerStatusNotice } from '@ohos/screenlockcommon/Index';
import { GestureBackMetaBallModel } from '@ohos/gestureback/src/main/ets/metaball/viewmodel/GestureBackMetaBallModel';
import { GestureBackMetaBall } from '@ohos/gestureback/src/main/ets/metaball/view/GestureBackMetaBall';
import lazy { SwipeInwardBackModel } from '../touchboardgesture/SwipeInwardBackModel';
import lazy { PadBackEventViewModel } from '../gesturenavigation/back/viewmodel/PadBackEventViewModel';
import {
  GestureBackMetaBallCallBack
} from '@ohos/gestureback/src/main/ets/metaball/viewmodel/GestureBackMetaBallCallBack';
import { GestureDockViewModel } from '../gestureDock/dock/viewmodel/GestureDockViewModel';
import { gestureBackSettings } from '@ohos/gestureback/src/main/ets/common/GestureBackSettings';

const TAG = 'SCBGestureBack';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

@Component
export struct SCBGestureBack {
  persistentId: number = 0;
  @Link screenProperty: SCBScreenProperty;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('openFolderStatus') openFolderStatus: number = FeatureConstants.OPEN_FOLDER_STATUS_CLOSE;
  @StorageLink('isInBackGesture') isInBackGesture: boolean = false;
  @StorageLink('scenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @State imgTranslateX: number = 0;
  @State imgTranslateY: number = 0;
  @State imgAlpha: number = 0;
  @State viewController: BaseViewController = new BaseViewController(TAG);
  @State isGestureEnabled: boolean = true;
  @State isMetaBallCanvas: boolean = false;
  @State isLeftGesture: boolean = false;
  @State navBarHeight: number = StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
  @State navSideWidth: number = gestureBackSettings.getBackResponseRegionWidth();
  @State meltBallBrightness : string = SCBConstants.LIGHT_COLOR_MODE_MELTBALL_BRIGHTNESS;
  private screenX: number = this.screenProperty.width;
  private screenY: number = this.screenProperty.height;
  private metaBallModel: GestureBackMetaBallModel = GestureBackMetaBallModel.getInstance();
  // private gestureDockPullOutModel: GestureDockPullOutModel = GestureDockPullOutModel.getInstance();
  // private gestureDockPullOutData: GestureDockPullOutData = GestureDockPullOutModel.getInstance().pullOutData;
  private backViewModel: SCBGestureBackViewModel | null = null;
  private leftResponseViewModel: BackEventViewModel | null = null;
  private rightResponseViewModel: BackEventViewModel | null = null;
  // 触控板内滑手势回调
  private swipeInwardBackModel: SwipeInwardBackModel | null = null;
  private isPad: boolean = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD;

  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_SCBGestureNavBar`,
    onLock: (): void => this.onLockReceived(),
    onUnlock: (): void => this.onUnLockReceived()
  };

  private onLockReceived(): void {
    log.showInfo('onLockReceived');
    // this.gestureDockPullOutData.isLock = true;
    // 锁屏场景，恢复back手势热区
    this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived');
    // this.gestureDockPullOutData.isLock = false;
  }

  private backResponseViewModelCallBack: BackEventViewModelCallBack = {

    // back手势识别失败
    onRecognizeFail: (reason: GestureFailReason) => {
      this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
    },

    // back手势开始滑动
    onBackGestureStart: (event: GestureEvent, isLeftGesture: boolean, startY: number) => {
      log.showInfo(`onBackGestureStart:${startY}`);
      this.isLeftGesture = isLeftGesture;
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_BACK, true);
      this.isInBackGesture = true;
      this.isMetaBallCanvas = true;
      this.metaBallModel.finishUpAnim();
      this.backViewModel?.setBackResponseRegion(true, this.screenX, this.screenY);
      // this.gestureDockPullOutModel.setIsLeft(isLeftGesture);
      // this.gestureDockPullOutModel.resetPullOutDockParam();
      this.metaBallModel.initPoint(event, this.isLeftGesture,
        px2vp(this.screenX), px2vp(this.screenY), this.metaBallCallBack);
    },

    // back手势跟手滑动
    onBackGestureUpdate: (isLeftGesture: boolean, event: GestureEvent, processAnim: number) => {
      this.metaBallModel.handleActionMove(event);
    },

    // back手势松手
    onBackGestureEnd: () => {
      // this.gestureDockPullOutData.actionUpTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      this.metaBallModel.finishChangeDockImgAnim();
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_BACK, false);
      this.isInBackGesture = false;
      this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
      this.metaBallModel.handleUpAnimation();
    },

    // back手势Cancel
    onBackGestureCancel: () => {
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_BACK, false);
      this.isInBackGesture = false;
      this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
      this.metaBallModel.handleUpAnimation();
      // this.gestureDockPullOutModel.pullInGestureDock();
      this.isMetaBallCanvas = false;
    },

    // back手势识别成功用户cancel
    onBackGestureCancelForUser: () => {
      // 如果Dock栏回收动效做完了，下树Dock
      // this.gestureDockPullOutModel.pullInGestureDock();
    },

    onSendClickEventTo: (downEvent: TouchEvent, upEvent: TouchEvent) => {
      this.backViewModel?.sendClickEvent(downEvent, upEvent);
    },

    onSendGestureBackTo: (isLeftArea: boolean, event: GestureEvent) => {
      this.processAndReportBackEvent(isLeftArea, event);
    }
  }

  private metaBallCallBack: GestureBackMetaBallCallBack = {
    onExtrudeBallsBegin: (): void => {
      GestureDockViewModel.getInstance().getViewEvent()?.onExtrudeBallsBegin();
    },
    onExtrudeBallsFinish: (): void => {
      // this.gestureDockPullOutModel.onExtrudeBallsFinish();
    },
    onMoveBackBallsBegin: (): void => {
      // this.gestureDockPullOutModel.onMoveBackBallsBegin();
    },
    onMoveBackBallsFinish: (): void => {
      // this.gestureDockPullOutModel.onMoveBackBallsFinish();
    },
    onHandUpAnimFinish: (): void => {
      log.showInfo('anim finish...');
      if (this.isInBackGesture) {
        log.showInfo('is in back gesutre, not skip draw SCBGestureBack.');
        return;
      }
      // back融球动效结束时回调
      let sysSceneSession =
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
      // 动画结束后通知不可见
      if (sysSceneSession) {
        sysSceneSession.setSkipDraw(true);
      }
      this.isMetaBallCanvas = false;
    }
  }

  private processAndReportBackEvent(isLeftArea: boolean, event: GestureEvent): void {
    // 呼出Dock，不下发Back事件 侧边栏入口屏蔽
    /*if (!this.gestureDockPullOutModel.isSendBackEventOnGestureEnd()) {
      log.showInfo('pull out gesture dock, not send back event.');
      return;
    }*/
    // 结合if判断是否下发Back事件
    log.showInfo(`processAndReportBackEvent. isLeftArea=${isLeftArea}`);
    this.backViewModel?.processBackEvent(GestureType.BACK, event);
    let containerSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList().getTopActiveSession();
    HiSysEventUtil.reportBackEvent(HiSysBackEventData.SUCCESS, isLeftArea ? 'left' : 'right',
      containerSession?.isMidScene, containerSession?.getBundleName() ?? 'desktop');
    sEventManager.publish(obtainLocalEvent(EventConstants.BACK_GESTURE, true));
  }

  private restoreGestureBack(): void {
    this.isInBackGesture = false;
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_BACK, false);
    this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
  }

  /**
   * 更新左右组件宽度、距离底部的高度
   */
  private updateGestureNavSize(): void {
    if (this.backViewModel !== null) {
      this.navSideWidth = this.backViewModel.gestureNavSidWidth;
      this.navBarHeight = this.backViewModel.navSideDistToBottom;
    }
    log.showInfo(`${TAG} updateGestureNavSize navSideWidth = ${this.navSideWidth} ` +
      `navBarHeight = ${this.navBarHeight}`);
  }

  aboutToAppear(): void {
    viewMgrPolicy.registerViewController(TAG, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.backViewModel = singletonBackViewModel;
    this.backViewModel?.init(this.persistentId, SCBDefaultZIndex.GESTURE_BACK, this.screenProperty);
    this.backViewModel?.registerRotateAnimaChangeCallBack();
    this.initResponseViewModel();
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    // 默认触发窗口不可见
    if (sysSceneSession) {
      sysSceneSession.setSkipDraw(true);
    }
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        if (reason === SCBPropertyChangeReason.ROTATION && this.isInBackGesture) {
          let responseViewModel = this.isLeftGesture ? this.leftResponseViewModel : this.rightResponseViewModel;
          responseViewModel?.onPanGestureActionCancel();
        }
        this.viewController.updateRect({
          left: 0,
          top: 0,
          width: px2vp(screenProperty.width),
          height: px2vp(screenProperty.height)
        });
        this.screenX = screenProperty.width;
        this.screenY = screenProperty.height;
        this.backViewModel?.setBackResponseRegion(false, this.screenX, this.screenY);
      })
    scbGestureManager.registerGestureEnabledCallback(GestureType.BACK, (isEnable: boolean) => {
      if (this.isGestureEnabled !== isEnable) {
        log.showInfo(`${TAG} registerGestureEnabledCallback ${isEnable}`);
      }
      this.isGestureEnabled = isEnable;
      if (sysSceneSession) {
        sysSceneSession.setSessionTouchable(isEnable);
      }
      if (!isEnable && this.isInBackGesture) {
        let responseViewModel = this.isLeftGesture ? this.leftResponseViewModel : this.rightResponseViewModel;
        responseViewModel?.onPanGestureActionCancel();
      }
    });
    scbGestureManager.registerPcKeyCallback(TAG, (type: PcKeyType) =>{
      this.backViewModel?.registerPcKeyCallback(type, this.isGestureEnabled)
    });
    DebugCommandsUtils.registerDebugCommands(this.imgTranslateX, this.imgTranslateY);
    scbEventExclusiveManager.registerEventExclusive(EventType.GESTURE_BACK, () => {
      let isInBackGesture = scbEventExclusiveManager.getEventExclusiveByCaller(EventType.GESTURE_BACK);
      if (isInBackGesture || this.isInBackGesture) {
        scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_BACK, false);
        let responseViewModel = this.isLeftGesture ? this.leftResponseViewModel : this.rightResponseViewModel;
        responseViewModel?.onPanGestureActionCancel();
      }
    })
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_SLEEP, (data?: PowerStatusNotice) => {
      scbEventExclusiveManager.restoreAllEventExclusiveByHard();
    });
  }

  private initResponseViewModel(): void {
    if (this.isPad || DeviceHelper.isUltraScreenProduct()) {
      this.leftResponseViewModel = new PadBackEventViewModel(this.persistentId,
        SCBDefaultZIndex.GESTURE_BACK, true, this.backResponseViewModelCallBack);
      this.rightResponseViewModel = new PadBackEventViewModel(this.persistentId,
        SCBDefaultZIndex.GESTURE_BACK, false, this.backResponseViewModelCallBack);
      this.swipeInwardBackModel = new SwipeInwardBackModel(this.leftResponseViewModel, this.rightResponseViewModel,
        this.screenX, this.screenY);
      this.swipeInwardBackModel.registerSwipeInwardCallback();
    } else {
      this.leftResponseViewModel = new BackEventViewModel(this.persistentId,
        SCBDefaultZIndex.GESTURE_BACK, true, this.backResponseViewModelCallBack);
      this.rightResponseViewModel = new BackEventViewModel(this.persistentId,
        SCBDefaultZIndex.GESTURE_BACK, false, this.backResponseViewModelCallBack);
    }
    log.showInfo(`initResponseViewModel gestureNavSidWidth = ${this.backViewModel?.gestureNavSidWidth} ` +
      `navSideDistToBottom = ${this.backViewModel?.navSideDistToBottom}`);
  }

  private onColorModeChange(): void {
    log.showInfo(`updateBrightness colorMode=${this.currColorMode}`);
    if (this.currColorMode === SmallFolderConstants.DARK_COLOR_MODE) {
      // 1、深色模式 brightness设置1.05
      this.meltBallBrightness = SCBConstants.DARK_COLOR_MODE_MELTBALL_BRIGHTNESS;
    } else {
      // 1、浅色模式 brightness设置0.95
      this.meltBallBrightness = SCBConstants.LIGHT_COLOR_MODE_MELTBALL_BRIGHTNESS;
    }
    log.showInfo(`updateBrightness this.meltBallBrightness=${this.meltBallBrightness}`);
  }

  aboutToDisappear(): void {
    this.backViewModel?.unRegisterRotateAnimaChangeCallBack();
    scbGestureManager.unRegisterGestureEnabledCallback(GestureType.BACK);
    scbGestureManager.unregisterPcKeyCallback(TAG);
    if (this.isPad || DeviceHelper.isUltraScreenProduct()) {
      this.swipeInwardBackModel?.unRegisterSwipeInwardCallback();
      this.swipeInwardBackModel = null;
    }
  }

  build() {
    if (this.isGestureEnabled) {
      Stack() {
        // back
        if (this.isMetaBallCanvas) {
          GestureBackMetaBall();
        }

        // Gesture back left area
        BackEventView({
          isLeftGesture: true,
          screenProperty: this.screenProperty,
          responseViewModel: this.leftResponseViewModel,
          navSideWidth: this.navSideWidth,
        });

        // Gesture back right area
        BackEventView({
          isLeftGesture: false,
          screenProperty: this.screenProperty,
          responseViewModel: this.rightResponseViewModel,
          navSideWidth: this.navSideWidth,
        });

      }
      .align(Alignment.Bottom)
      .position({ x: 0, y: ResUtils.getNumber($r('app.float.status_bar_phone_height')) })
      .width('100%')
      .height(px2vp(this.screenProperty.height) - ResUtils.getNumber($r('app.float.status_bar_phone_height')) -
      this.navBarHeight)
      .onAccessibilityHoverTransparent((event: TouchEvent) => {
        let responseViewModel = this.isLeftGesture ? this.leftResponseViewModel : this.rightResponseViewModel;
        responseViewModel?.onAccessibilityHoverTransparent(event);
      })
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down && scbEventExclusiveManager.getAllEventExclusive() && this.isInBackGesture &&
          event.touches.length === 1) {
          log.showInfo('back gesture restore itself.');
          this.restoreGestureBack();
        }
        log.showInfo('onTouch');
      })
      .focusable(false)
      .accessibilityLevel((this.isAccessibilityMode) ? 'no-hide-descendants' : 'auto')
      .hitTestBehavior(this.isInBackGesture ? HitTestMode.Block : HitTestMode.Default)
    }
  }
}
