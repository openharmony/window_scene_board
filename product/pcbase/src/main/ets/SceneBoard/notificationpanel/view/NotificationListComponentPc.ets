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

import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { PIN_TOP_APPS_LIMIT, PinTopAppItem, default as PinTopLimitDialog } from '@ohos/systemuicommon/src/main/ets/dialog/PinTopLimitDialog';
import { NotificationListContent } from '@ohos/notificationcomponent/src/main/ets/pages/phone/NotificationListContent';
import { NtfCloseVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfCloseVM';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { NtfListScrollController } from '@ohos/notificationcomponent/src/main/ets/controller/NtfListScrollController';
import { ntfSettingsDC } from '@ohos/notificationcomponent/src/main/ets/controller/NtfSettingsDialogController';
import { notificationConfigManager } from '@ohos/notificationcomponent/src/main/ets/manager/NotificationConfigManager';
import { ResetItemSwipeEvent } from '@ohos/notificationcomponent/src/main/ets/common/event/NotificationEvent';
import { NotificationConstants } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConstants';
import NTF_LIST_VM_HOLDER from '@ohos/notificationcomponent/src/main/ets/model/NtfListVmHolder';
import { pinTopLimitDC } from '@ohos/notificationcomponent/src/main/ets/controller/PinTopLimitDialogController';
import { NtfSettingsDialogVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfSettingsDialogVM';
import { NotificationListStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationListStyle';
import { NtfColorModeVM, NtfColorModeConfig } from '@ohos/notificationcomponent/src/main/ets/vm/NtfColorModeVM';
import { ntfViewConfigManager } from '@ohos/notificationcomponent/src/main/ets/vm/config/NtfViewConfigManager';
import { CommonUtils, Log, RectInfo } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { ResUtils, SCBFoldStatePropertyChangeEvent, ScbNumber, SCBScreenSessionManager } from '@ohos/windowscene';
import { PinTopConfigCommand } from '@ohos/systemuicommon';
import { NotificationCenterTitlePc } from './NotificationCenterTitlePc';
import { NotificationEmptyTipPc } from './NotificationEmptyTipPc';
import { BrightnessOptionUtils, EventBroadcast, SysUiWindowType } from '@ohos/systemuicommon/Index';
import { NtfAnimVMPC } from '../vm/NtfAnimVMPC';
import { NtfListVmPc } from '../vm/NtfListVmPc';
import { NtfListContentConfigPc } from './NtfViewConfigPc';
import screenSessionManager from '@ohos.screenSessionManager';

/**
 * 通知卡片动效类型
 */
enum AnimType {
  NONE,
  DOWN, // 通知入场
  UP, // 通知入场反悔
  DISAPPEAR // 通知退场
}

const TAG = NotificationConstants.NTF_LOG_PREFIX + 'NotificationListComponentPc';
const COMPONENT_ID_CONTAINER = `${TAG}_Column_container`;
const HORIZONTAL_SCROLLING = 9;
const PIN_TOP_DIALOG_HEIGHT = 378;


enum PintopDialogPosition {
  VERTICAL_CREASE_REGION = 0,
  HORIZONTAL_CENTER = 1,
  VERTICAL_B_SIDE_CENTER = 2
};

/**
 * 通知列表组件，通知面板
 *
 * @since 2022-12-10
 */
@Component
export struct NotificationListComponentPc {
  /**
   * y轴下拉跟手系数
   */
  transYCoefficient: number = 2 / 3;

  private currentPinTopEntry: NotificationEntry | null = null;

  private PinTopLimitDialogHeight: number = 450;

  /*
   * 针对hopper折叠/展开;键盘呼出/收起 时的应用通知置顶超限制弹框适配
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
  /*
   * 通知中心整体高度（加上标题高度后），用于更新通知中心面板高度
   */
  private ntfHeight: number = 0;

  private defaultEmptyListTipOpacity: number = 1;

  /**
   * VM
   */
  private ntfListVmPc: NtfListVmPc = new NtfListVmPc();

  /**
   * 通知动效vm
   */
  ntfAnimVMPC: NtfAnimVMPC = new NtfAnimVMPC();

  /**
   * 列表滑动控制器
   */
  private listScroller: NtfListScrollController = new NtfListScrollController();

  /*
   * 通知中心标题高度
   */
  private titleHeight: number = ResUtils.getNumber($r('app.float.ntf_center_header_pc_height'));
  /**
   * 通知卡片动效类型
   */
  @Provide animType: AnimType = AnimType.NONE;

  /**
   * 通知进入动效不开启clip
   */
  @Provide ntfListClipEnable: boolean = false;

  /**
   * 通知面板类型，默认下拉面板
   */
  @Provide notificationType: number = NotificationType.TYPE_PC;

  /**
   * 通知列表数据是否为空
   */
  @Provide isNtfListEmpty: boolean = true;

  /**
   * 是否显示全部清除按钮
   */
  @Provide isShowClearButton: boolean = false;

  /**
   * 是否横屏
   */
  @Provide isDisplayLand: boolean = false;

  /**
   * 是否折叠屏展开
   */
  @Provide isFoldFullDisplay: boolean = false;

  /**
   * 窗口面板是否可见
   */
  @Provide isNtfWindowShow: boolean = false;

  /**
   * 面板触摸down点，全局Y轴点，-1无触摸
   */
  @Provide panelDownGlobalY: number = -1;

  /**
   * 面板触摸down点，全局X轴点，-1无触摸
   */
  @Provide panelDownGlobalX: number = -1;

  /**
   * 通知条目列表宽度
   */
  @State ntfPanelWidth: string = '100%';

  /**
   * 面板左侧间距
   */
  @State ntfPanelLeftMargin: string = CommonUtils.splicePx(0);

  /**
   * 面板右侧间距
   */
  @State ntfPanelRightMargin: string = CommonUtils.splicePx(0);

  /**
   * 面板头部/无通知 跟随滑动位移距离
   */
  @Provide ntfFollowTranY: number = 0;
  @Provide ntfTitleFollowTranY: number = 0;

  /**
   * 列表头元素的y轴位移
   */
  @Provide listHeadTranY: number = 0;

  /**
   * 跟随位移时动画
   */
  @Provide ntfFollowAnim: AnimateParam | null = null;
  @Prop viewOpacity: number | null = null;
  @State phoneNtfCenterTitleOpacity: number = 0;
  @State ntfAreaRect: RectInfo = new RectInfo();
  @Prop @Watch('getListMaxHeight') windowMaxHeight: Length = Infinity;
  @State listMaxHeight: Length = Infinity;

  @State ntfListTranslate: number = 0;

  /*
   * 通知中心组件可见部分宽度
   */
  @Provide ntfComponentWidth: number = 0;

  /*
   * 通知中心组件可见部分高度
   */
  @Provide ntfComponentHeight: number = 0;

  /**
   * 锁屏是否加锁状态
   */
  @Provide isKeyguardLock: boolean = false;

  @State isShowNtfEmptyTips: boolean = false;

  /**
   * 通知中心更新面板高度回调函数
   */
  updateHeight: (height: number) => void = () => {};

  colorModeVM: NtfColorModeVM = new NtfColorModeVM();
  /**
   * 当前通知面板是否显示
   */
  private isShow: boolean = false;
  @Link isAssemblyPanelShow: boolean;

  /**
   * 确定了需要取消置顶的app列表后的回调
   *
   * @param list 需要取消置顶的app列表
   */
  onCancelPinTopItemSelected = (list: Set<PinTopAppItem>) => {
    let configList : PinTopConfigCommand[] = [];
    list.forEach((item : PinTopAppItem) => {
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
        pinTopLimitDC.hideDialog(this.getNtfType());
        ntfSettingsDC.hideDialog(this.getNtfType());
      }
    })
  }

  showPinTopDialog = async (enable: boolean): Promise<void> => {
    let ntfEntry = (ntfSettingsDC.getSettingsDialogVM(this.getNtfType()) as NtfSettingsDialogVM)
      .getNtfEntry() as NotificationEntry;
    if (enable) {
      let count = await notificationConfigManager.getPinTopCount();
      if (count >= PIN_TOP_APPS_LIMIT) {
        Log.showInfo(TAG, 'showPinTopDialog')
        this.currentPinTopEntry = ntfEntry;
        ntfSettingsDC.hideDialog(this.getNtfType());
        pinTopLimitDC.showDialog(this.getNtfType(), this.pinTopDialogBSideCenterController);
        return;
      }
    }

    notificationConfigManager.setPinTopState(
      ntfEntry?.creatorUid,
      enable
    );
    this.postCloseSwipeEvent(ntfEntry);
    ntfSettingsDC.hideDialog(this.getNtfType());
  }

  onPinTopOperationCancel = (): void => {
    pinTopLimitDC.hideDialog(this.notificationType)
    Log.showInfo(TAG, 'onPinTopOperationCancel');
  }

  private pinTopDialogCreaseRegionController: CustomDialogController = new CustomDialogController({
    builder: PinTopLimitDialog({
      onSelected: this.onCancelPinTopItemSelected,
      onCancel: this.onPinTopOperationCancel,
      pinTopLimitDialogHeight: this.PinTopLimitDialogHeight,
      ntfHeight: this.ntfHeight
    }),
    autoCancel: false,
    alignment: DialogAlignment.Top,
    offset: { dx: 0, dy: - ( PIN_TOP_DIALOG_HEIGHT / 2.0 )},
    showInSubWindow: true,
    width: 400,
    height: PIN_TOP_DIALOG_HEIGHT,
    cornerRadius: 16
  })

  /*
   B面居中的应用通知置顶数量超限制弹框, 用于折叠PC竖屏非展开场景以及普通PC
   */
  private pinTopDialogBSideCenterController: CustomDialogController = new CustomDialogController({
    builder: PinTopLimitDialog({
      onSelected: this.onCancelPinTopItemSelected,
      onCancel: this.onPinTopOperationCancel,
      pinTopLimitDialogHeight: this.PinTopLimitDialogHeight,
      ntfHeight: this.ntfHeight
    }),
    autoCancel: false,
    alignment: DialogAlignment.Top,
    // hopper: 展开时全屏居中;其他场景B面居中
    offset: { dx: 0, dy: ( - PIN_TOP_DIALOG_HEIGHT) / 2.0 },
    showInSubWindow: true,
    width: 400,
    height: PIN_TOP_DIALOG_HEIGHT,
    cornerRadius: 16
  })

  /*
   * 折叠PC 横屏展开态置顶超限弹窗
   * */
  private pinTopDialogHorizontalController: CustomDialogController = new CustomDialogController({
    builder: PinTopLimitDialog({
      onSelected: this.onCancelPinTopItemSelected,
      onCancel: this.onPinTopOperationCancel,
      pinTopLimitDialogHeight: this.PinTopLimitDialogHeight,
      ntfHeight: this.ntfHeight
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    showInSubWindow: true,
    width: 400,
    height: PIN_TOP_DIALOG_HEIGHT,
    cornerRadius: 16
  })

  private updateVisibleAreaChange = (isVisible: boolean, currentRatio: number) => {
    if (isVisible && currentRatio >= 0.9 && !this.isShow) {
      // 广播通知中心显示
      EventBroadcast.broadcastEvent(SysUiWindowType.WINDWO_NTF_CENTER, true);
      this.isShow = true;
      Log.showInfo(TAG, `${SysUiWindowType.WINDWO_NTF_CENTER} show`);
    }
    if (!isVisible && currentRatio <= 0.1 && this.isShow) {
      // 广播通知中心隐藏
      EventBroadcast.broadcastEvent(SysUiWindowType.WINDWO_NTF_CENTER, false);
      this.isShow = false;
      Log.showInfo(TAG, `${SysUiWindowType.WINDWO_NTF_CENTER} hide`);
    }
  }

  postCloseSwipeEvent(ntfEntry: NotificationEntry) {
    let event = ResetItemSwipeEvent.create(this.getNtfType(), ntfEntry?.getGroupKey(), ntfEntry?.hashCode);
    EvtBus.post(ResetItemSwipeEvent, event);
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
    // 当窗口不可见时，滑动回第一个条目
    if (!isWindowShow) {
      this.listScroller?.scrollToFirst();
    }
  }

  /**
   * 横竖屏切换状态回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isLand 是否横屏
   */
  onDisplayLandStateChange(isLand: boolean): void {
    this.isDisplayLand = isLand;
  }

  /**
   * 面板样式属性变换回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param ntfStyle 样式属性
   */
  onNtfStyleChange(ntfStyle: NotificationListStyle): void {
    this.ntfPanelLeftMargin = ntfStyle.ntfRootLeftPadding;
    this.ntfPanelRightMargin = ntfStyle.ntfRootRightPadding;
    this.ntfPanelWidth = ntfStyle.ntfListWidth;
  }

  /**
   * 通知列表是否为空状态切换
   * 复写NtfListVm.NtfListCallback
   *
   * @param isNtfListEmpty true无数据
   */
  onNtfListEmptyStateChange(isNtfListEmpty: boolean): void {
    this.isNtfListEmpty = isNtfListEmpty;
    Log.showInfo(TAG, 'onNtfListEmptyStateChange: ' + isNtfListEmpty);
  }

  /**
   * 通知列表清空按钮状态切换
   * 复写NtfListVm.NtfListCallback
   *
   * @param isShowClearButton true显示清空按钮
   */
  onClearButtonStateChange(isShowClearButton: boolean): void {
    this.isShowClearButton = isShowClearButton;
    Log.showInfo(TAG, 'onClearButtonStateChange: ' + isShowClearButton);
  }

  /**
   * 折叠屏显示状态变化回调
   * 复写NtfListVm.NtfListCallback
   *
   * @param isFullDisplay 是否全屏显示
   */
  onFoldDisplayModeChange(isFullDisplay: boolean): void {}

  getListMaxHeight(): void {
    if (this.windowMaxHeight === Infinity || Number.isNaN(this.windowMaxHeight)) {
      return;
    }
    const listBottomEdgeClip: number = 2; // 列表底部超出双描边部分剪裁
    this.listMaxHeight = ResUtils.getNumberFromLength(this.windowMaxHeight) - this.titleHeight - listBottomEdgeClip;
  }

  @Builder
  buildEmptyTip() {
    NotificationEmptyTipPc()
  }

  aboutToAppear(): void {
    Log.showInfo(TAG, 'aboutToAppear type: ' + this.notificationType);
    // VM 初始化
    NTF_LIST_VM_HOLDER.setNtfListVm(this.notificationType, this.ntfListVmPc);
    this.ntfListVmPc.init(this);
    this.onWindowStateChange(true);

    const lightConfig: NtfColorModeConfig = {
      bgBrightnessOption: BrightnessOptionUtils.getInstance().getBackgroundFiveOption(false),
      foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerOption,
      foregroundPrimary: BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight,
      foregroundPrimaryBackground: BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight,
      themeFontForegroundOptions: BrightnessOptionUtils.getInstance().foregroundSecondaryOption,
      themeNtfTextPrimaryColor: $r('app.color.Control_center_long_button_font_on_color'),
      extraNtfContentColor: $r('app.color.Control_center_long_button_font_on_color'),
      centerNtfTitleColor: $r('app.color.Control_center_long_button_font_on_color'),
      buttonImageNtfColor: $r('app.color.Control_center_long_button_font_on_color'),
      themeNtfTextSecondary: $r('app.color.Control_center_long_button_font_on_color')
    };
    const darkConfig: NtfColorModeConfig = {
      bgBrightnessOption: BrightnessOptionUtils.getInstance().getBackgroundFiveOption(true),
      foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerDarkOption,
      foregroundPrimary: BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark,
      foregroundPrimaryBackground: BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark,
      themeFontForegroundOptions: BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption,
      themeNtfTextPrimaryColor: $r('app.color.Control_center_long_button_font_on_color_dark'),
      extraNtfContentColor: $r('app.color.Control_center_long_button_font_on_color_dark'),
      centerNtfTitleColor: $r('app.color.Control_center_long_button_font_on_color_dark'),
      buttonImageNtfColor: $r('app.color.Control_center_long_button_font_on_color_dark'),
      themeNtfTextSecondary: $r('app.color.Control_center_long_button_font_on_color_dark')
    };
    this.colorModeVM.init(lightConfig, darkConfig);
    this.ntfAnimVMPC.init();
    ntfViewConfigManager.setListContentConfig(new NtfListContentConfigPc());
  }

  aboutToDisappear(): void {
    Log.showInfo(TAG, 'aboutToDisappear type: ' + this.notificationType);
    // 清空缓存
    ntfSettingsDC.hideDialog(this.notificationType);
    ntfSettingsDC.setDialogController(this.notificationType, null);
    pinTopLimitDC.hideDialog(this.notificationType);
    this.ntfListVmPc.onDestroy();
    NTF_LIST_VM_HOLDER.deleteNtfListVm(this.notificationType);
    this.colorModeVM.deinit();
  }

  build() {
    if (this.isAssemblyPanelShow) {
      // 1、EffectComponent组件用于解决卡片堆叠时透出的问题。
      EffectComponent() {
        Stack() {
          Column() {
            // PC面板，面板头
            NotificationCenterTitlePc({
              ntfListVM: this.ntfListVmPc,
              ntfAnimVM: this.ntfAnimVMPC
            })
              .opacity(this.viewOpacity as number)
            Row() {
              NotificationListContent({
                ntfListVM: this.ntfListVmPc,
                ntfAnimVM: this.ntfAnimVMPC,
                listScroller: this.listScroller,
                changeAppPinTopConfig: this.showPinTopDialog,
                ntfAreaRect: $ntfAreaRect,
                colorModeVM: this.colorModeVM,
                isNtfShow: true,
                isEnableScrollAnimation: false,
                closeVM: new NtfCloseVM(),
                maxHeight: this.listMaxHeight,
                emptyListTipOpacity: this.defaultEmptyListTipOpacity,
                emptyTipBuilder: () => {
                  this.buildEmptyTip()
                },
                ntfListTranslate: $ntfListTranslate,
                isShowNtfEmptyTips: this.isShowNtfEmptyTips,
                backgroundFocusable: false
              })
                .width('100%')
                .constraintSize({
                  maxHeight: this.listMaxHeight,
                })
                .opacity(this.viewOpacity as number)
            }
            .width('100%')
            .layoutWeight(1)
            .constraintSize({
              maxHeight: this.listMaxHeight,
            })
          }
          .margin({
            left: this.ntfPanelLeftMargin,
            right: this.ntfPanelRightMargin
          })
          .width(this.ntfPanelWidth)
          .height('100%')
          .id(COMPONENT_ID_CONTAINER)
        }
        .margin(1)
        .onVisibleAreaChange([0.0, 1.0], this.updateVisibleAreaChange)
        .onTouch((event) => {
          if (event) {
            switch (event.type as TouchType) {
              case TouchType.Down:
                // 记录down点
                this.panelDownGlobalY = event.touches[0].screenY;
                break;
              case TouchType.Up:
              case TouchType.Cancel:
                this.panelDownGlobalY = -1;
                break;
              default:
                break;
            }
          }
        })
        .onMouse((event: MouseEvent) => {
          if (event.button === MouseButton.Right && event.action === MouseAction.Press) {
            this.panelDownGlobalY = -2;
          }

          if (event.sourceTool === HORIZONTAL_SCROLLING) {
            // 触摸屏双指水平滑动事件传递
            this.panelDownGlobalY = event.windowY;
          }
        })
      }
      .backgroundEffect({
        // 模糊半径设置成0，表示这一层不做模糊，复用一级面板的模糊。
        radius: 0,
        // 设置成1.01的目的是让EffectComponent组件生效。
        brightness: 1.01
      })
    }
  }
}

