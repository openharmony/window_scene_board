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

import { NotificationListStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationListStyle';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import {
  ntfSettingsDC as NtfSettingsDC
} from '@ohos/notificationcomponent/src/main/ets/controller/NtfSettingsDialogController';
import { notificationConfigManager } from '@ohos/notificationcomponent/src/main/ets/manager/NotificationConfigManager';
import { NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DropDownEvent,
  EvtBus,
  TargetPanel,
  sEventManager,
  obtainLocalEvent,
} from '@ohos/frameworkwrapper';
import { ResUtils, sSCBOobeManager } from '@ohos/windowscene';
import PinTopLimitDialog, {
  PinTopAppItem
} from '@ohos/systemuicommon/src/main/ets/dialog/PinTopLimitDialog';
import {
  silenceDialogDC as SilenceDialogDC
} from '@ohos/notificationcomponent/src/main/ets/controller/SilenceDialogController';
import SilenceDialog from '@ohos/systemuicommon/src/main/ets/dialog/SilenceDialog';
import { ResetItemSwipeEvent } from '@ohos/notificationcomponent/src/main/ets/common/event/NotificationEvent';
import NTF_LIST_VM_HOLDER from '@ohos/notificationcomponent/src/main/ets/model/NtfListVmHolder';
import {
  pinTopLimitDC as PinTopLimitDC
} from '@ohos/notificationcomponent/src/main/ets/controller/PinTopLimitDialogController';
import { ImmersiveNtfListComponent } from './ImmersiveNtfListComponent';
import { NtfSettingsDialogVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfSettingsDialogVM';
import systemDateTime from '@ohos.systemDateTime';
import { BusinessError } from '@ohos.base';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import {
  ListWgBindStateType,
  SysFloatTipDialog,
  WidgetAnimState
} from '@ohos/screenlockcommon/Index';
import {
  CcmOption,
  DisplayUtils,
  ScreenLockNotificationConst,
  SlWidgetId,
  SlVisualControl
} from '@ohos/screenlockcommon/';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveAnimKey } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersivePanelState } from '../../viewmodel/viewdata/ImmersivePanelState';
import { ImmersiveListHandle } from '../../viewmodel/viewevent/ImmersiveListHandle';
import { immersiveFgCtrl } from '../../model/service/ImmersiveFingerControll';
import {
  immersiveKgMgr,
  ImmersiveState,
  PinTopConfigCommand,
  ImmersiveType,
  SystemuiConstants,
  NotificationSysEventReporter
} from '@ohos/systemuicommon/';
import { SlListWidgetBindState } from '../../model/data/SlListWidgetBindState';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { ImmersiveListVm } from '../../viewmodel/ImmersiveListVm';
import { SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ImmersiveMeshManager } from '../../viewmodel/viewlayout/ImmersiveMeshManager';
import { NtfListBindState } from '../../viewmodel/viewdata/NtfListState';
import {
  ImmUeDataHelper,
  UeDataComp,
  UeDataType
} from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmUeDataHelper';

const TAG = 'ImmersiveKeyguardComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 排除小图标
const BOTTOM_PADDING = 100;

/**
 * 沉浸锁屏面板
 * 锁屏通知列表 + 沉浸卡片页面
 */
@Component
export struct ImmersiveKeyguardListComponent {
  /**
   * 沉浸动效管理器
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();

  /**
   * 列表事件处理器
   */
  private listHandle: ImmersiveListHandle = immersiveVm.getImmersiveListHandle();

  /**
   * 列表VM
   */
  private listVm: ImmersiveListVm = immersiveVm.getImmersiveListVm();

  /**
   * 网格管理器
   */
  private meshMgr: ImmersiveMeshManager = immersiveVm.getImmersiveMeshManager();

  /**
   * 通知列表动效状态
   */
  @State listAnimState?: WidgetAnimState = this.animMgr.getListAnimState(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);

  /**
   * 通知面板类型，默认下拉面板
   */
  @Provide notificationType: number = NotificationType.TYPE_PHONE_KEYGUARD;

  /**
   * 是否折叠屏展开
   */
  @Provide isFoldFullDisplay: boolean = false;

  /**
   * 窗口面板是否可见
   */
  @Provide isNtfWindowShow: boolean = false;

  /**
   * 通知条目列表宽度
   */
  @State ntfPanelWidth: string = '100%';

  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState()

  @StorageLink('dropDownEvent') @Watch('onDropDownEventChange') dropDownEvent: DropDownEvent =
    DropDownPanelManager.getDropDownEvent();

  /**
   * 通知图标与指纹图标冲突
   */
  @Prop isNtfFingerprintConflict: boolean;

  private currentPinTopEntry: NotificationEntry | null = null;
  private currentSilenceEntry: NotificationEntry | undefined = undefined;

  /**
   * VM
   */
  private ntfListVM: NtfListKeyGuard = new NtfListKeyGuard();
  /**
   * 锁屏时间
   */
  @Provide lockScreenTime: number = -1;
  private hasSetNtfSwipe2CollapseForDropDown: boolean = false;

  /**
   * 锁屏是否加锁状态
   */
  @Provide isKeyguardLock: boolean = false;

  /**
   * 沉浸面板状态
   */
  @State panelState: ImmersivePanelState = this.listVm.getPanelState();
  /**
   * 沉浸面板状态
   */
  @State listBindState: NtfListBindState = this.listVm.getListBindState();

  // 锁屏首页通知列表组件状态
  @State slListBindState?: SlListWidgetBindState = immersiveStateHelper.getSlListBindState() as SlListWidgetBindState;

  // 锁屏首页通知列表动效管理
  @State slListAnimState?: WidgetAnimState = immersiveStateHelper.getSlListAnimState() as WidgetAnimState;

  /**
   * 确定了需要取消置顶的app列表后的回调
   *
   * @param list 需要取消置顶的app列表
   */
  onCancelPinTopItemSelected = (list: Set<PinTopAppItem>) => {
    let configList: PinTopConfigCommand[] = [];
    list.forEach((item: PinTopAppItem) => {
      configList.push({
        uid: item.uid,
        enable: false
      })
    })

    // 取消未勾选的应用的置顶
    notificationConfigManager.batchSetPinTopState(configList).then((isSuccess: boolean) => {
      if (isSuccess) {
        // 开启当前应用置顶
        notificationConfigManager.setPinTopState(
          (this.currentPinTopEntry as NotificationEntry)?.creatorUid,
          true
        );
        // 收起面板
        this.postCloseSwipeEvent(this.currentPinTopEntry as NotificationEntry);
        PinTopLimitDC.hideDialog(this.getNtfType());
        NtfSettingsDC.hideDialog(this.getNtfType());
      }
    })
  }
  showPinTopDialog = async (enable: boolean): Promise<void> => {
    let dialogVm = NtfSettingsDC.getSettingsDialogVM(this.getNtfType()) as NtfSettingsDialogVM;
    let ntfEntry = dialogVm.getNtfEntry() as NotificationEntry;
    if (enable) {
      let count = await notificationConfigManager.getPinTopCount();
      if (count >= SystemuiConstants.PIN_TOP_APPS_LIMIT) {
        this.currentPinTopEntry = ntfEntry;
        NtfSettingsDC.hideDialog(this.getNtfType());
        if (this.pinTopDialogController != null) {
          PinTopLimitDC.showDialog(this.getNtfType(), this.pinTopDialogController);
        }
        return;
      }
    }

    notificationConfigManager.setPinTopState(
      ntfEntry?.creatorUid,
      enable
    );
    this.postCloseSwipeEvent(ntfEntry);
    NtfSettingsDC.hideDialog(this.getNtfType());
  }

  onPinTopOperationCancel = (): void => {
    PinTopLimitDC.hideDialog(this.notificationType);
  }

  private pinTopDialogController: CustomDialogController | null = new CustomDialogController({
    builder: PinTopLimitDialog({
      onSelected: this.onCancelPinTopItemSelected,
      onCancel: this.onPinTopOperationCancel,
      statusBarHeight: ResUtils.getNumber($r('app.float.status_bar_phone_height'))
    }),
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  //展示静默弹窗
  showSilenceDialog = async (): Promise<void> => {
    log.showInfo('showSilenceDialog');
    let ntfEntry = NtfSettingsDC.getNtfEntryByType(this.getNtfType());
    this.currentSilenceEntry = ntfEntry;
    NtfSettingsDC.hideDialog(this.getNtfType());
    SilenceDialogDC.showDialog(this.getNtfType(), this.silenceDialogController);
  }
  private silenceDialogController: CustomDialogController = new CustomDialogController({
    builder: SilenceDialog({
      cancel: () => {
        this.onSilenceDialogCancel()
      },
      confirm: () => {
        this.onSilenceDialogAccept()
      },
      silenceDialogTitle: ResUtils.getInnerStringNumS($r('app.string.silence_dialog_title'),
        (this.currentSilenceEntry as NotificationEntry)?.appLabel),
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  })

  onSilenceDialogCancel() {
    NtfSettingsDC.hideDialog(this.getNtfType());
    SilenceDialogDC.hideDialog(this.getNtfType());
    log.showInfo('silence dialog click cancel');
  }

  async onSilenceDialogAccept() {
    NtfSettingsDC.hideDialog(this.getNtfType());
    SilenceDialogDC.hideDialog(this.getNtfType());
    let ntfEntry = NtfSettingsDC.getNtfEntryByType(this.getNtfType());
    const result =
      await notificationConfigManager.setSilentState(
        (this.currentSilenceEntry as NotificationEntry)?.creatorUid,
        (this.currentSilenceEntry as NotificationEntry)?.creatorBundleName,
        true
      );
    // 静默打点
    NotificationSysEventReporter.notificationSilence({
      CREATOR_BUNDLE_NAME: ntfEntry?.creatorBundleName,
      IS_SILENCE_STATE_ON: 1,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
    log.showInfo('silence dialog click accept,result is ' + result);
  }

  aboutToAppear(): void {
    try {
      this.lockScreenTime = systemDateTime.getTime();
    } catch (e) {
      let error = e as BusinessError;
      log.showError(`Failed to get time. message: ${error.message}, code: ${error.code}`);
      this.lockScreenTime = Number.MAX_VALUE;
    }
    log.showWarn(`aboutToAppear, start lockScreenTime: ${this.lockScreenTime}`);

    // VM 初始化
    NTF_LIST_VM_HOLDER.setNtfListVm(this.notificationType, this.ntfListVM);
    this.ntfListVM.init(this);
    immersiveVm.initVm();

    this.onWindowStateChange(true);
    NtfSettingsDC.setSettingEvents(this.notificationType, {
      changeSilenceConfig: this.showSilenceDialog,
      changeAppPinTopConfig: this.showPinTopDialog,
    });

    // 初始化指纹管理
    immersiveFgCtrl.init();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    // 清空缓存
    NtfSettingsDC.hideDialog(this.notificationType);
    SilenceDialogDC.hideDialog(this.notificationType);
    PinTopLimitDC.hideDialog(this.notificationType);
    immersiveVm.destroy();
    this.ntfListVM.onDestroy();
    NtfSettingsDC.deleteSettingEvents(this.notificationType);
    NTF_LIST_VM_HOLDER.deleteNtfListVm(this.notificationType);
    this.pinTopDialogController = null;
  }

  build() {
    Stack({ alignContent: this.panelState.listAlign }) {
      // 列表最大高度监控
      Stack()
        .width('100%')
        .height('100%')
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.listHandle.setListHeight(newValue?.height as number);
          this.listVm.getListStaticState().listMaxPositionY = newValue?.globalPosition.y as number;
          let maxH = newValue?.height as number;
          this.meshMgr.setNotificationHeightMax(maxH);
          let slListBindState = immersiveStateHelper.getSlListBindState();
          slListBindState?.setSlState(ListWgBindStateType.NTF_LIST_ITEM_HEIGHT_MAX, maxH);
        })

      EffectComponent() {
        ImmersiveNtfListComponent({
          ntfListVM: this.ntfListVM,
          isNtfFingerprintConflict: this.isNtfFingerprintConflict
        })
          .padding({
            bottom: this.panelState.listBottomPadding,
            left: DisplayUtils.isLargeScreen() ? 0 : ImmersiveConstants.NTF_LIST_PADDING,
            right: DisplayUtils.isLargeScreen() ? 0 : ImmersiveConstants.NTF_LIST_PADDING
          })
          .width(this.ntfPanelWidth)
          .enabled(this.isListEventEnable())
          .visibility(this.getListVisibility())
      }
      .backgroundEffect(this.getEffect())
      .width(this.ntfPanelWidth)
      .freeze(this.isBlurFreeze())
      .translate(this.getImmersiveListTranslate())

      Stack()
        .height(this.listBindState.listRealHeight as number)
        .width('100%')
        .id(SlWidgetId.IMMERSIVE_LIST_FOR_ADO)
        .hitTestBehavior(HitTestMode.None)
    }
    .id(SlWidgetId.IMMERSIVE_LIST_SHOW_AREA)
    .margin({ top: this.panelState.marginTop })
    .width('100%')
    .height(`calc(100% - ${this.panelState.marginTop})`)
    .hitTestBehavior(HitTestMode.None)
    .overlay(this.buildSysFloatTipDialog(),
      { align: Alignment.Bottom, offset: { x: 0, y: 0 - (this.panelState.paddingBottom + BOTTOM_PADDING) } })
    .opacity(this.getRootAlpha())
    .scale(this.getRootScale())
    .padding({ top: this.panelState.paddingTop, bottom: this.panelState.paddingBottom + BOTTOM_PADDING })
  }

  @Builder
  buildSysFloatTipDialog() {
    SysFloatTipDialog({ componentId: ScreenLockNotificationConst.NTF_KEY_GUARD_TIP })
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)
  }

  private getRootAlpha(): number | undefined {
    let alpha = this.getAlpha();
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.LIST_ONE, UeDataType.OPACITY, alpha);
    return alpha;
  }

  private getAlpha(): number | undefined {
    if (this.slListAnimState?.isSceneAnimating()) {
      return this.slListAnimState?.getAlpha() ?? this.slListBindState?.getLayoutOpacity();
    }
    return this.slListBindState?.getLayoutOpacity();
  }

  private getRootScale(): ScaleOptions | undefined {
    if (this.slListAnimState?.isSceneAnimating()) {
      return {
        x: this.slListAnimState?.getScaleX() ?? this.slListBindState?.getLayoutScale(),
        y: this.slListAnimState?.getScaleY() ?? this.slListBindState?.getLayoutScale(),
      };
    }
    return {
      x: this.slListBindState?.getLayoutScale() ?? 1,
      y: this.slListBindState?.getLayoutScale() ?? 1,
    };
  }

  private getEffect(): BackgroundEffectOptions | undefined {
    if (!SlVisualControl.getInstance().getEnable(CcmOption.SOLID) &&
      !SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT)) {
      return ImmersiveConstants.IMMERSIVE_CLOCK_SOLID_BLUR_CFG;
    }
    return undefined;
  }

  postCloseSwipeEvent(ntfEntry: NotificationEntry) {
    let event = ResetItemSwipeEvent.create(this.getNtfType(), ntfEntry?.getGroupKey(), ntfEntry?.hashCode);
    EvtBus.post(ResetItemSwipeEvent, event);
  }

  getLockScreenTime(): number {
    return this.lockScreenTime;
  }

  /**
   * 获取通知面板类型
   * 复写NtfListVm.NtfListCallback
   *
   * @return 通知类型
   */
  getNtfType(): number {
    return this.notificationType;
  }

  /**
   * 窗口面板可见性变化回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isWindowShow 窗口是否可见
   */
  onWindowStateChange(isWindowShow: boolean): void {
    this.isNtfWindowShow = isWindowShow;
  }

  /**
   * 横竖屏切换状态回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isLand 是否横屏
   */
  onDisplayLandStateChange(isLand: boolean): void {
  }

  /**
   * 面板样式属性变换回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param ntfStyle 样式属性
   */
  onNtfStyleChange(ntfStyle: NotificationListStyle): void {
    this.ntfPanelWidth = ntfStyle.ntfListWidth;
  }

  /**
   * 通知列表是否为空状态切换
   * 复写NtfListVm.NtfListCallback
   *
   * @param isNtfListEmpty true无数据
   */
  onNtfListEmptyStateChange(isNtfListEmpty: boolean): void {
  }

  /**
   * 通知列表清空按钮状态切换
   * 复写NtfListVm.NtfListCallback
   *
   * @param isShowClearButton true显示清空按钮
   */
  onClearButtonStateChange(isShowClearButton: boolean): void {
  }

  /**
   * 折叠屏显示状态变化回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isFullDisplay 是否全屏显示
   */
  onFoldDisplayModeChange(isFullDisplay: boolean): void {
    this.isFoldFullDisplay = isFullDisplay;
  }

  /**
   * 锁屏加锁状态变化回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isKeyguardLock 锁屏是否在加锁状态
   */
  onKgLockStateChange(isKeyguardLock: boolean): void {
    this.isKeyguardLock = isKeyguardLock;
    let slStaticState = immersiveStateHelper.getSlStaticState();
    slStaticState?.setSlState(SlStaticStateType.SL_SECURE_LOCKED_STATE, isKeyguardLock);
  }

  private onDropDownEventChange(): void {
    const enable = this.dropDownEvent.target === TargetPanel.NONE;
    this.hasSetNtfSwipe2CollapseForDropDown = this.publishLocalEvent(enable, this.hasSetNtfSwipe2CollapseForDropDown);
  }

  private publishLocalEvent(enable: boolean, changedParameter: boolean): boolean {
    if (enable) {
      return false;
    } else if (!changedParameter) {
      sEventManager.publish(
        obtainLocalEvent(ScreenLockNotificationConst.SCREENLOCK_NTF_NEED_TO_SWIPE_TO_COLLAPSE, false));
      return true;
    }
    return changedParameter;
  }

  private isListEventEnable(): boolean {
    if (this.immersiveState.immersiveType === ImmersiveType.TYPE_LIST) {
      return true;
    }
    return false;
  }

  private isBlurFreeze(): boolean { // 是否冻结模糊
    return this.slListBindState?.isBgBlurSceneFreeze() ?? false;
  }

  private getImmersiveListTranslate(): TranslateOptions {
    if (this.listAnimState?.isSceneAnimating()) {
      return {
        x: this.listAnimState.getTranX() ?? 0,
      };
    }
    return {
      x: 0,
    };
  }

  /**
   * 获取通知列表可见性
   *
   * @returns 可见性
   */
  private getListVisibility(): Visibility {
    let visibility = this.getVisibility();
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.LIST_ONE, UeDataType.VISIBILITY, visibility);
    return visibility;
  }

  private getVisibility(): Visibility {
    // OOBE阶段 隐藏通知列表
    if (sSCBOobeManager.isEnable()) {
      return Visibility.Hidden;
    }
    // 通知列表动效中，保持可见
    if (this.listAnimState?.isSceneAnimating()) {
      return Visibility.Visible;
    }
    return this.immersiveState?.isShowList() ? Visibility.Visible : Visibility.Hidden;
  }
}
