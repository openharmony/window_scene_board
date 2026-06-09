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

import osAccount from '@ohos.account.osAccount';
import display from '@ohos.display';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  ViewCallback,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { UserUnlockedEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import {
  AbstractInitialAble,
  DisplayUtils,
  FingerprintConstants,
  KeyGuardPage,
  KeyguardStatusService,
  screenLockInnerStateManager,
  ScreenLockVerifyService,
  KeyGuardMode,
  VerifyDataManager,
  FaceUnlockReason,
} from '@ohos/screenlockcommon';
import {
  DisplayStateListener,
  DisplayStateManager,
  FrequentFoldManager
} from '@ohos/screenlockcommon/Index';
import {
  SlMainStateType,
  SlStaticStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import { MonitorManager } from '@ohos/screenlockcomponent/src/main/ets/monitor/MonitorManager';
import {
  CoreStateType,
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { IInitialized } from '@ohos/systemuicommon';
import lazy { OuterHomeManager } from '../common/OuterHomeManager';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { slComStateMgr } from '../model/manager/SlCommonStateManager';
import { ScreenLockInitializeService } from '../model/service/ScreenLockInitializeService';
import lazy {
  OuterScreenLockImmersiveChangeAnimationVc
} from '../component/subviewcontrol/OuterScreenLockImmersiveChangeAnimationVc';
import { slCtxHelper } from '@ohos/screenlockcommon/Index';
import { OneMirrorStrategyContext } from '@ohos/screenlockcomponent/src/main/ets/onemirror/strategy/OneMirrorStrategyContext';

const TAG = 'RootViewController'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const MILLISECOND_TO_HALF_SECOND: number = 500;

const MAX_SCREEN_OFF_DELAY_TIME: number = 2000;
const IS_ULTRA_SCREEN = DeviceHelper.isUltraScreenProduct();
const FOLD_STATUS_EXPANDED: number = 1;
const FOLD_STATUS_HALF_FOLDED: number = 3;
const FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED: number = 12;
const FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED : number = 22;

// 锁屏初始化服务列表
const SL_INIT_LIST: IInitialized[] = [
  new ScreenLockInitializeService()
];

enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

interface InitParam {
  persistentId: number,
  context?: Context,
  uiContext?: UIContext
}

/**
 * 锁屏根控件控制器
 */
export class RootVc extends AbstractInitialAble {
  private _persistentId: number = 0;
  private readonly _slObserverProxy: SlObserverProxy = new SlObserverProxy();
  private readonly eventMgr: EventManager = EvtBus.createEventManager(); // 事件管理
  private openFaceAuthTimeoutId: number = 0;
  private outerScreenLockImmersiveChangeAnimationVc: OuterScreenLockImmersiveChangeAnimationVc | undefined = undefined;
  private currentFoldStatus: number = -1;
  private readonly onUserUnlockedEvent = (_event: UserUnlockedEvent): void => { // 账号认证解锁事件
    this.updateOsAccountUnlockState();
  };

  private slViewCallback: ViewCallback = {
    // 锁屏面板各事件回调
    onShow: () => {
      slStateHelper.getSlBindState()?.setSlShowing(true); // 可见性状态刷新
    },
    onHide: () => {
      screenLockInnerStateManager.onExitKeyguard();
      slStateHelper.getSlBindState()?.setSlShowing(false);
    }
  };

  private displayStateListener: DisplayStateListener = {
    onFoldStatusChange: (foldStatus: number): void => {
      let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE); // 刷新折叠展开状态
      let isFoldFullDisplay: boolean = foldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED;
      log.showInfo(`isFoldFullDisplay: ${isFoldFullDisplay}, foldStatus ${foldStatus}`);
      AppStorage.setOrCreate('isFoldFullDisplay', isFoldFullDisplay);
      slStaticState?.setSlState(SlStaticStateType.FOLD_EXPAND_STATE, foldStatus);
    },
    onFoldStateChange: (isFoldExpand: boolean): void => {
      log.showInfo(`isFoldExpand ${isFoldExpand}, isFrequentFoldChange: ${FrequentFoldManager.getInstance().isFrequentFoldChange}`);
      if (FrequentFoldManager.getInstance().isFrequentFoldChange) {
        return;
      }
      if (isFoldExpand) {
        this.openFaceAuthTimeoutId = setTimeout(() => {
          this.openFaceAuthTimeoutId = 0;
          ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true,
            FaceUnlockReason.FOLD_CHANGED);
        }, MILLISECOND_TO_HALF_SECOND);
      } else {
        this.clearOpenFaceAuthTimeout();
      }
    },
    onOrientationChange: (orientation: number) => {
      let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
      // 刷新屏幕旋转状态，0,2时处于竖屏状态，非魔鬼数字
      slStaticState?.setSlState(SlStaticStateType.PORTRAIT_STATE, orientation === 0 || orientation === 2);
    },
  };

  protected doInit(initParam: InitParam): void {
    log.showInfo('doInit');
    this._persistentId = initParam.persistentId;
    // UIContext缓存
    slCtxHelper.setUiContext(initParam.uiContext);

    this.slAppear(initParam.context);

    this.initUiContext(initParam.uiContext);

    this._slObserverProxy.getCoreFsmState(this._persistentId,
      (oldState: CoreStateType, newState: CoreStateType): void => this.handleCoreFsmStateChange(oldState, newState));

    // 初始化一镜到底服务
    this.initOneMirrorService();

    // 初始化字体缩放工具类
    sFontScaleUtil.init();

    // 初始化外部依赖的属性变化监听
    this.initStateChangeListenerForOther();

  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this.slDisappear();

    // 释放一镜到底服务
    this.releaseOneMirrorService();

    // 释放字体缩放工具类
    sFontScaleUtil.release();

    // 清空代理监听
    this._slObserverProxy.release();

    // UIContext释放
    slCtxHelper.setUiContext();
  }

  private slAppear(context?: Context): void { // 锁屏面板上树
    this.initService(context);
    ViewManagerPolicy.registerViewCallback(ViewType.KEYGUARD, this.slViewCallback);
    MonitorManager.getInstance().init(); // 监控器初始化
    this.initObserverDisplayStatusChange(); // 监听折叠屏事件
    slComStateMgr.init(context); // 开启状态管理
    this.eventMgr.on(UserUnlockedEvent, this.onUserUnlockedEvent); // 监听账号认证解锁事件
    this.updateOsAccountUnlockState(); // 初始化锁定状态

    this.initCurrentFoldStatus();
    this.registerFoldStatusListener();
  }

  private initCurrentFoldStatus(): void {
    if (!IS_ULTRA_SCREEN) {
      return;
    }
    this.currentFoldStatus = DisplayUtils.getFoldStatus();
    this.updateVerifyStatus(this.currentFoldStatus);
  }

  /**
   * 注册折叠屏状态监听
   *
   */
  private registerFoldStatusListener(): void {
    if (!IS_ULTRA_SCREEN) {
      return;
    }
    log.showInfo('registerFoldStatusListener enter');
    try {
      display.on('foldStatusChange', this.onFoldStateChangeCallback);
    } catch (error) {
      log.showError('registerFoldStatusListener on error');
    }
  }

  /**
   * 注销折叠监听
   */
  private unRegisterFoldStatusListener(): void {
    if (!IS_ULTRA_SCREEN) {
      return;
    }
    log.showInfo('unRegisterListener enter');
    try {
      display.off('foldStatusChange', this.onFoldStateChangeCallback);
    } catch (error) {
      log.showError('unRegisterFoldStatusListener on error');
    }
  }

  private onFoldStateChangeCallback = (newFoldStatus: display.FoldStatus) => {
    log.showInfo(`newFoldStatus: ${newFoldStatus}`);
    if (this.currentFoldStatus === newFoldStatus) {
      return;
    }
    this.currentFoldStatus = newFoldStatus;
    this.updateVerifyStatus(newFoldStatus);
  };

  private isNeedDisableFace(foldStatus: number): boolean {
    return foldStatus === FOLD_STATUS_EXPANDED || foldStatus === FOLD_STATUS_HALF_FOLDED ||
      foldStatus === FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED ||
      foldStatus === FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED;
  }

  private updateVerifyStatus(foldStatus: number): void {
    if (this.isNeedDisableFace(foldStatus)) {
      VerifyDataManager.getInstance().updateVerifyDisable(AuthType.FACE, true);
    } else {
      VerifyDataManager.getInstance().updateVerifyDisable(AuthType.FACE, false);
    }
  }

  private slDisappear(): void { // 锁屏面板下树
    ViewManagerPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.slViewCallback);
    MonitorManager.getInstance().destroy();
    this.releaseObserverDisplayStatusChange();
    slComStateMgr.destroy();
    this.eventMgr.offAll();

    this.unRegisterFoldStatusListener();

    this.clearOpenFaceAuthTimeout();
  }

  private initService(ctx?: Context): void { // 初始化服务
    SL_INIT_LIST.forEach((service) => service?.init(ctx));
    ArrayUtils.clearArr(SL_INIT_LIST); // 内存回收
  }

  private clearOpenFaceAuthTimeout(): void {
    if (this.openFaceAuthTimeoutId !== 0) {
      this.openFaceAuthTimeoutId = 0;
      clearTimeout(this.openFaceAuthTimeoutId);
    }
  }

  private updateOsAccountUnlockState(): void { // 刷新账号认证解锁状态
    try {
      osAccount.getAccountManager()?.isOsAccountUnlocked().then((isVerified: boolean) => {
        slStateHelper.getSlBindState()?.setOsAccountUnlocked(isVerified);
      });
    } catch (error) {
      log.showError('onSlShowingChange isOsAccountUnlocked err.');
    }
  }

  private isNeedObserverDisplayStatus(): boolean {
    return DisplayUtils.isFoldAble() || DeviceHelper.isSmallFoldProduct();
  }

  private initObserverDisplayStatusChange(): void {
    log.showInfo(`The device is flodable: ${DisplayUtils.isFoldAble()}`);
    // LEM产品的isFoldable状态为false,但是实际为折叠屏.故增加!DeviceHelper.isSmallFoldProduct()的判断.
    if (!this.isNeedObserverDisplayStatus()) {
      return;
    }
    AppStorage.setOrCreate('isFoldFullDisplay',
      DisplayUtils.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_FOLDED);
    // 折叠设备状态初始化
    let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    slStaticState?.setSlState(SlStaticStateType.FOLDABLE_STATE, DisplayUtils.isFoldAble());
    slStaticState?.setSlState(SlStaticStateType.FOLD_EXPAND_STATE, DisplayUtils.getFoldStatus());
    DisplayStateManager.getInstance().registerObserver(this.displayStateListener);
  }

  private releaseObserverDisplayStatusChange(): void {
    if (!this.isNeedObserverDisplayStatus()) {
      return;
    }
    DisplayStateManager.getInstance().unRegisterObserver(this.displayStateListener);
  }

  private initOneMirrorService(): void {
    OneMirrorStrategyContext.getInstance().init();
    OuterHomeManager.getInstance().init(this._persistentId);
    if (!OuterHomeManager.getInstance().hasInit()) {
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(MAX_SCREEN_OFF_DELAY_TIME);
    }
  }

  private releaseOneMirrorService(): void {
    OneMirrorService.getInstance().release();
    OuterHomeManager.getInstance().release();
  }

  private handleCoreFsmStateChange(oldState: CoreStateType, newState: CoreStateType): void {
    log.showInfo(`fsm state: [${CoreStateType[oldState]} -> ${CoreStateType[newState]}]`);
    if (oldState !== newState) {
      this.updateStorageForOther(newState);
    }
  }

  /**
   * 更新外部依赖的存储字段
   */
  private updateStorageForOther(stateType: CoreStateType): void {
    // 外部依赖，状态栏依赖
    AppStorage.setOrCreate('isPwdVisible', CoreStateTypeUtils.isInNormalBounce(stateType));
    AppStorage.setOrCreate('enableControllerCenter',
      !CoreStateTypeUtils.isInSimCheckBounce(stateType) && !KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE));

    // 外部依赖，控制中心依赖
    AppStorage.setOrCreate('lockStatus',
      CoreStateTypeUtils.isUnlockStateScreenOn(stateType) ? ScreenLockStatus.UNLOCK : ScreenLockStatus.LOCKING);

    if (CoreStateTypeUtils.isUnlockStateScreenOn(stateType)) {
      KeyguardStatusService.switchToPage(KeyGuardPage.EXIT_PAGE);
    }
  }

  /**
   * 更新外部依赖的存储字段
   */
  private initStateChangeListenerForOther(): void {
    this._slObserverProxy.getVerifyInfo(AuthType.FINGERPRINT, verifyInfo => {
      if (verifyInfo?.sensorInfo) {
        // 外部依赖，AOD依赖
        log.showInfo(`set fingerprint x position ${verifyInfo?.sensorInfo.coordinateY}`);
        AppStorage.setOrCreate(FingerprintConstants.COORDINATE_Y_OF_FINGERPRINT_UD_SCREEN_IN_PX,
          verifyInfo?.sensorInfo.coordinateY);
        AppStorage.setOrCreate(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY,
          verifyInfo?.sensorInfo.sensorType);
        AppStorage.setOrCreate(FingerprintConstants.FINGERPRINT_UD_SENSOR_RADIUS_IN_PX_KEY,
          verifyInfo?.sensorInfo.radius);
        AppStorage.setOrCreate(FingerprintConstants.COORDINATE_X_OF_FINGERPRINT_UD_SCREEN_IN_PX,
          verifyInfo?.sensorInfo.coordinateX);
        AppStorage.setOrCreate(FingerprintConstants.COORDINATE_Y_OF_FINGERPRINT_UD_SCREEN_IN_PX,
          verifyInfo?.sensorInfo.coordinateY);
      }
      AppStorage.setOrCreate(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT, verifyInfo.isSupportUnlock);
    });
  }

  private initUiContext(uiContext?: UIContext): void {
    if (!uiContext) {
      log.showError('initUiContext err for invalid uiContext');
      return;
    }

    let slStaticState = slStateHelper.getSlStaticState();
    if (!slStaticState) {
      log.showError('initUiContext err for invalid slStaticState');
      return;
    }

    slStaticState.setUiContext(uiContext);
  }
}