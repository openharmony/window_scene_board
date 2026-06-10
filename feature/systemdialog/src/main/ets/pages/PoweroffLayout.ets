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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { accessibility } from '@kit.AccessibilityKit';
import { config } from '@kit.AccessibilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, Logger } from '@ohos/basicutils';
import PowerOffStyleConstants from '../common/PoweroffStyleConstants';
import { poweroffController } from '../controller/PoweroffController';
import { PowerOffSysEventUtil, ShutdownPanelState } from '../common/PowerOffSysEventUtil';
import { PowerOffTaskPoolUtil } from '../common/PowerOffTaskPoolUtil';
import { AnimationManager } from '../common/AnimationManager';
import { PowerOnSchedule } from './PowerOnSchedule';
import { ResourceUtil } from '../common/ResourceUtil';
import { PowerOffFind } from './PowerOffFind';
import { LayoutUtils } from '@ohos/systemuicommon';
import display from '@ohos.display';
import { MeasureUtils } from '@kit.ArkUI';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'PowerOff-Layout';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const textFontSize = PowerOffStyleConstants.POWEROFF_BUTTON_TEXT_FONT_SIZE;

const DELAY_FOCUS = 1;
const ACCESS_ID_SHUTDOWN = 'PowerOff_Layout_shutdownButton__FOCUS';
const ACCESS_ID_REBOOT = 'PowerOff_Layout_rebootButton__FOCUS';
enum Mode {
  NORMAL = 0,
  REBOOT_ACTIVATING = 1,
  LOADING = 2,
  POWER_OFF_ACTIVATING = 3,
}

enum ButtonState {
  NORMAL = 0,
  ACTIVATING = 1
}

interface ClickEventHandler {
  handleClick: () => void
}

@Component
export struct PoweroffLayout {
  @Prop blankTopHeight: Length;
  @Prop buttonMinSpace: number;
  @Prop tipsWidth: string;
  @Prop blankBottomHeight: Resource;
  tipsInfo?: Resource;
  tipsLineHeight?: Resource;
  @Prop tipsHeight: string | number;
  private textTipsTransition: TransitionEffect = AnimationManager.TEXT_TIPS_TRANSITION;

  @State rebootTransition: TransitionEffect = AnimationManager.INITIAL_REBOOT_TRANSITION;
  @State powerOffTransition: TransitionEffect = AnimationManager.INITIAL_POWER_OFF_TRANSITION;
  @State currentMode: Mode = Mode.NORMAL;
  // 提示文本默认颜色:白色
  @State tipInfoFontColor: Resource = $r('app.color.poweroff_text_tips_color');
  // 无障碍模式下播报文本
  @State accessibilityPowerOff: Resource = $r('app.string.accessibility_power_off');
  @State accessibilityReboot: Resource = $r('app.string.accessibility_reboot');
  @State accessibilityClickPowerOff: Resource = $r('app.string.Poweroff_Button_Click_Shutdown');
  @State accessibilityClickReboot: Resource = $r('app.string.Poweroff_Button_Click_Reboot');
  @State accessibilityBack: Resource = $r('app.string.accessibility_back');
  // 提示气泡
  @State customPopup: boolean = false;
  @State customPopupMessage: ResourceStr = '';
  @State isPhoneLandscape: boolean = false;
  /**
   * 是否选中定时开机
   */
  @State isCheckedPowerOn: boolean = false;
  /**
   * 定时开机选项是否打开
   */
  @State isOpenPowerOnSwitch: boolean = false;
  /**
   * 是否显示关机查找复选框
   */
  @Prop isOffFindEnabled: boolean;
  /**
   * 关机查找组件左右边距
   */
  @State powerOffOptionsMargin: Length = $r('app.float.poweroff_option_margin');
  /**
   * 管家查找组件底边距
   */
  @State powerOffOptionMarginBottom:Length = this.getPowerOffOptionMarginBottom();
  /**
   * 折叠状态
   */
  @Prop @Watch('onFoldStatusChange') isExpand: boolean;
  /**
   * XT设备折叠状态
   */
  @Prop @Watch('onFoldDisplayModeChange') foldDisplayMode: display.FoldDisplayMode;
  /**
   * 设备宽度
   */
  @Prop @Watch('onDisplayWidthChange') displayWidth: number;
  /**
   * 是否横屏状态
   */
  @Prop @Watch('onLandscapeStateChange') isLandscape: boolean;
  /**
   * 存放按钮和文本的容器宽度
   */
  @State buttonAndTextWidth: Length = 'auto';
  /**
   * 文本最大放大倍数
   */
  @State maxFontScale: number = PowerOffStyleConstants.POWEROFF_MAX_FONT_SCALE;
  /**
   * 如果从折叠态到展开态，需要忽略横竖屏状态
   */
  private isFormFolded: boolean = !DeviceHelper.isFoldExpandedOrHalf();
  /**
   * 超时任务Flag
   */
  timer: number = 0;
  private scroller: Scroller = new Scroller();
  private scrollerTip: Scroller = new Scroller();
  /**
   * 设置是否返回结果
   */
  /**
   * 同步状态到关机模块
   */
  indexHandleOffFindEnabledStatus: (status: boolean) => void = () => {
  };

  public isFinished: CustomPromise<void> = new CustomPromise();
  // KeyOptions
  private winBackOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_BACK,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  initPhoneLandscape() {
    this.isPhoneLandscape = poweroffController.isPhoneLandScape();
  }

  aboutToAppear() {
    log.showWarn(TAG, 'aboutToAppear');
    PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
      ShutdownPanelState.ENTER_SHUTDOWN_PANEL);
    this.getHighContrastTextState();
    this.initPhoneLandscape();
    this.powerOffOptionsMargin = this.getMarginWidth();
    this.calcMaxFontScale();
    setTimeout(() => {
      this.rebootTransition = AnimationManager.REBOOT_TRANSITION;
      this.powerOffTransition = AnimationManager.POWER_OFF_TRANSITION;
      // 判断是否在无障碍状态
      if (accessibility.isOpenAccessibilitySync()) {
        ResourceUtil.requestFocusAccessibility(ACCESS_ID_REBOOT);
        // 无障碍模式下监听keyCode事件
        this.registerKeyEvent();
      }
    }, 100);
  }

  aboutToDisappear() {
    try {
      if (accessibility.isOpenAccessibilitySync()) {
        // 取消监听多模的KeyCode事件
        inputConsumer.off('key', this.winBackOption, this.onChangeCurrentMode);
      }
    } catch (error) {
      log.showError(TAG, `unRegisterkeyEvent failed, error: ${error?.message}`);
    }
  }

  // 关机页面:首页与二次页面切换
  onChangeCurrentMode = () => {
    // 关机页面首页
    if (this.currentMode === Mode.NORMAL) {
      // 销毁关机页面
      poweroffController.destroy();
      PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
        ShutdownPanelState.SHUTDOWN_CANCEL);
    } else if (this.currentMode === Mode.REBOOT_ACTIVATING || this.currentMode === Mode.POWER_OFF_ACTIVATING) {
      // 二次确认页面返回到关机首页
      this.handleClickAnimation(Mode.NORMAL);
    }
  }

  private onFoldStatusChange(): void {
    if (this.isFormFolded === !DeviceHelper.isFoldExpandedOrHalf()) {
      log.showInfo(TAG, 'status not change ,do not refresh data');
      return;
    }
    this.powerOffOptionsMargin = this.getMarginWidth();
    this.powerOffOptionMarginBottom = this.getPowerOffOptionMarginBottom();
    log.showInfo(TAG, `fold status change powerOffOptionsMargin ${this.powerOffOptionsMargin.toString()}`+
      `powerOffOptionMarginBottom ${this.powerOffOptionMarginBottom} isFormFolded ${this.isFormFolded}`);
    this.isFormFolded = !DeviceHelper.isFoldExpandedOrHalf();
  }

  private onFoldDisplayModeChange(): void {
    this.powerOffOptionsMargin = this.getMarginWidth();
  }

  private onLandscapeStateChange(): void {
    this.initPhoneLandscape();
    this.powerOffOptionsMargin = this.getMarginWidth();
    this.powerOffOptionMarginBottom = this.getPowerOffOptionMarginBottom();
  }

  private onDisplayWidthChange(): void {
  }

  // 监听多模的KeyCode事件
  registerKeyEvent() {
    log.showInfo(TAG, `registerKeyEvent`);
    try {
      inputConsumer.on('key', this.winBackOption, this.onChangeCurrentMode);
    } catch (error) {
      log.showError(TAG, `registerKeyEvent failed, error: ${error?.message}`);
    }
  }

  handleClickAnimation(mode: Mode) {
    animateTo(AnimationManager.CLICK_ANIMATION, () => {
      this.currentMode = mode;
    });
  }

  async handleConfirmPowerOff() {
    log.showInfo(TAG, `handle click power off switch:${this.isOpenPowerOnSwitch} isChecked:${this.isCheckedPowerOn}`);
    // "定时开关项打开"并且"取消选择"才通知设置
    if (this.isOpenPowerOnSwitch && !this.isCheckedPowerOn) {
      this.connectServiceAbility();
      this.timer = setTimeout(() => {
        log.showWarn(TAG, `timeout ${Date.now()}`);
        this.isFinished.resolve();
      }, 1000);
      await this.isFinished;
      PowerOffTaskPoolUtil.powerOff();
    } else {
      PowerOffTaskPoolUtil.powerOff();
    }
  }

  async handleConfirmPowerOffChr() {
    if (!this.isOffFindEnabled) {
      PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
        ShutdownPanelState.SHUTDOWN_CLOSE_OFF_FIND);
      log.showInfo(TAG, `power off temporarily close off find`);
    }
  }

  handleClickReboot = () => {
    if (this.currentMode === Mode.REBOOT_ACTIVATING) {
      this.currentMode = Mode.LOADING;
      PowerOffTaskPoolUtil.reboot();
    } else {
      this.handleClickAnimation(Mode.REBOOT_ACTIVATING);
    }
  }

  handleClickPowerOff = async (): Promise<void> => {
    if (this.currentMode === Mode.POWER_OFF_ACTIVATING) {
      try {
        log.showInfo(TAG, `handle click power off start, isOffFindEnabled ${this.isOffFindEnabled}`);
        if (this.isOffFindEnabled) {
          const isExecutePowerOff = await poweroffController.openUserAuthPage();
          log.showInfo(TAG, `isExecutePowerOff ${isExecutePowerOff}`);
          if (!isExecutePowerOff) {
            return;
          }
        }

        this.currentMode = Mode.LOADING;
        // 点击关机按钮前大数据打点
        this.handleConfirmPowerOffChr();
        // 点击关机按钮
        this.handleConfirmPowerOff();
      } catch (err) {
        log.showError(TAG, 'handle click power off error', err);
      }
    } else {
      this.handleClickAnimation(Mode.POWER_OFF_ACTIVATING);
    }
  }

  /**
   * loading
   */
  @Builder
  loadingSection() {
    Row() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color($r('sys.color.ohos_id_color_bottom_tab_bg'))
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .layoutWeight(1)
  }

  /**
   * 重启按钮
   */
  @Builder
  rebootButton() {
    RoundButtonAndText({
      icon: $r('app.media.ic_reboot'),
      fontColor: $r('app.color.poweroff_text_reboot_color'),
      accessibilityContent: this.accessibilityReboot,
      accessibilityClickContent: this.accessibilityClickReboot,
      currentMode: this.currentMode,
      columnTransition: this.rebootTransition,
      handleClick: { handleClick: this.handleClickReboot },
      normalStateText: $r('app.string.Poweroff_Button_Reboot'),
      activatingText: $r('app.string.Poweroff_Button_Click_Reboot'),
      textColor: $r('app.color.poweroff_text_reboot_color'),
      accessId: ACCESS_ID_REBOOT,
      buttonAndTextWidth: this.buttonAndTextWidth,
      maxFontScale: this.maxFontScale,
    })
  }

  /**
   * 关机按钮
   */
  @Builder
  powerOffButton() {
    RoundButtonAndText({
      icon: $r('app.media.ic_power_off'),
      fontColor: $r('app.color.poweroff_text_shutdown_color'),
      accessibilityContent: this.accessibilityPowerOff,
      accessibilityClickContent: this.accessibilityClickPowerOff,
      currentMode: this.currentMode,
      columnTransition: this.powerOffTransition,
      handleClick: { handleClick: this.handleClickPowerOff },
      normalStateText: $r('app.string.Poweroff_Button_Shutdown'),
      activatingText: $r('app.string.Poweroff_Button_Click_Shutdown'),
      textColor: $r('app.color.poweroff_text_shutdown_color'),
      accessId: ACCESS_ID_SHUTDOWN,
      buttonAndTextWidth: this.buttonAndTextWidth,
      maxFontScale: this.maxFontScale,
    })
  }

  /**
   * 下方提示文本
   */
  @Builder
  tipsSection() {
    Column() {
      Row() {
        Scroll(this.scrollerTip) {
          Column() {
            Text(this.tipsInfo)
              .fontFamily('HarmonyHeiTi')
              .fontWeight('Regular')
              .fontSize(PowerOffStyleConstants.POWEROFF_TIPS_FONT_SIZE)
              .fontColor(this.tipInfoFontColor)
              .textAlign((TextAlign.Center))
              .draggable(false)
              .maxFontScale(this.maxFontScale)
              .accessibilityLevel('yes')
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.End)
          .width(this.tipsWidth)
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        ScrollBar({ scroller: this.scrollerTip, direction: ScrollBarDirection.Vertical, state: BarState.Auto });
      }
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.Center)
      .constraintSize({ maxHeight: this.getTipMaxHeight() })
      .padding({
        left: PowerOffStyleConstants.POWEROFF_TIPS_PADDING,
        right: PowerOffStyleConstants.POWEROFF_TIPS_PADDING,
      })
    }
    .width('100%')
    .layoutWeight(1)
    .margin({ bottom: this.blankBottomHeight })
    .transition(this.textTipsTransition)
  }

  getTipMaxHeight(): Length {
    return this.isPhoneLandscape ? $r('app.float.poweroff_blank_top_height_phone_landscape')
      : $r('app.float.poweroff_option_max_height');
  }

  /**
   * 获取高对比度文字功能启用状态
   */
  private getHighContrastTextState(): void {
    config.highContrastText.get().then((state: boolean) => {
      log.showInfo(TAG, `succeeded in get highContrastText ${state}`);
      if (state) {
        // 高对比度模式下文本颜色: #ffffff
        this.tipInfoFontColor = $r('app.color.poweroff_text_reboot_color');
      }
    }).catch((err: BusinessError) => {
      log.showInfo(TAG, `highContrastText failed code ${err?.code}, message ${err?.message}`);
    })
  }

  @Builder
  bodyContentSection() {
    if (this.currentMode === Mode.LOADING) {
      this.loadingSection()
    } else {
      Row({ space: PowerOffStyleConstants.POWEROFF_TIPS_PADDING }) {
        if (this.currentMode !== Mode.POWER_OFF_ACTIVATING) {
          this.rebootButton();
        }
        if (this.currentMode !== Mode.REBOOT_ACTIVATING) {
          this.powerOffButton();
        }
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .layoutWeight(1)
      .padding({
        left: PowerOffStyleConstants.POWEROFF_TIPS_PADDING,
        right: PowerOffStyleConstants.POWEROFF_TIPS_PADDING,
      })

      if (this.currentMode === Mode.NORMAL) {
        this.tipsSection();
      }
      // 点击关机页面
      if (this.currentMode === Mode.POWER_OFF_ACTIVATING) {
        this.powerOffOptions();
      }
    }
  }

  @Builder
  popupBuilder() {
    Text(this.customPopupMessage)
      .fontSize($r('sys.float.ohos_id_text_size_body2'))
      .maxFontScale(2)
      .padding({
        left: 16,
        top: 8,
        right: 15,
        bottom: 9
      })
  }

  @Builder
  powerOffOptions() {
    Column() {
      Row() {
        Scroll(this.scroller) {
          Column() {
            // 关机查找
            PowerOffFind({
              handleOffFindEnabledStatus: (status: boolean): void => this.handleOffFindEnabledStatus(status),
              isOffFindEnabled: this.isOffFindEnabled,
              maxFontScale: this.maxFontScale,
            })
            // 定时关机
            PowerOnSchedule({
              handleShowToast: (message: ResourceStr): void => this.showToastTip(message),
              handleSwitchPowerOn: (isOpen: boolean): void => this.handleSwitchPowerOn(isOpen),
              handleChangeStatus: (status: boolean): void => this.handleChangeStatus(status)
            })
          }
          .bindPopup(this.customPopup, {
            builder: this.popupBuilder,
            targetSpace: 45,
            placement: Placement.Top,
            placementOnTop: true,
            autoCancel: false,
            enableArrow: false,
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.customPopup = false;
              }
            },
          })
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        ScrollBar({ scroller: this.scrollerTip, direction: ScrollBarDirection.Vertical, state: BarState.Auto });
      }
      .alignItems(VerticalAlign.Bottom) // row内子组件垂直方向上底部对齐
      .justifyContent(FlexAlign.Start) // row内子组件在水平方向上左对齐
      .constraintSize({ maxHeight: this.getMaxHeight() })
      .margin({ left: this.powerOffOptionsMargin, right: this.powerOffOptionsMargin })
    }
    .layoutWeight(1)
    .width('100%')
    .margin({ bottom: this.powerOffOptionMarginBottom })
  }

  /**
   * 显示气泡
   */
  showToastTip(message: ResourceStr): void {
    this.customPopup = true;
    this.customPopupMessage = message;
    setTimeout(() => {
      this.customPopup = false;
    }, 3000);
  }

  handleChangeStatus(status: boolean): void {
    log.showInfo(TAG, `handleChangeStatus ${status}`);
    this.isCheckedPowerOn = status;
  }

  handleSwitchPowerOn(isOpen: boolean): void {
    log.showInfo(TAG, `handleSwitchPowerOn ${isOpen}`);
    this.isOpenPowerOnSwitch = isOpen;
  }

  handleOffFindEnabledStatus(status: boolean): void {
    log.showInfo(TAG, `handleOffFindEnabledStatus ${status}`);
    this.isOffFindEnabled = status;
    this.indexHandleOffFindEnabledStatus(this.isOffFindEnabled);
  }

  /**
   * 多选框的最大高度
   */
  getMaxHeight(): Length {
    return this.isPhoneLandscape ? $r('app.float.poweroff_max_height_phone_landscape') :
    $r('app.float.poweroff_option_max_height');
  }

  /**
   * 两侧边距
   */
  getMarginWidth(): Length {
    // XT设备
    if (LayoutUtils.isXTProductType()) {
      if (this.foldDisplayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN && !DeviceHelper.isLandscape()) {
        return $r('app.float.poweroff_option_margin');
      } else {
        return $r('app.float.poweroff_option_margin_landscape');
      }
    }
    let margin: Length = $r('app.float.poweroff_option_margin_landscape');
    if (DeviceHelper.isPhone()) {
      if (DeviceHelper.isFold()) {
        // 大屏幕机
        if (!this.isExpand && !DeviceHelper.isLandscape()) {
          margin = $r('app.float.poweroff_option_margin');
        }
      } else {
        if (!DeviceHelper.isLandscape()) {
          margin = $r('app.float.poweroff_option_margin');
        }
      }
    }
    return margin;
  }

  getPowerOffOptionMarginBottom(): Length {
    return this.isPhoneLandscape && !this.isFormFolded ? $r('app.float.poweroff_option_margin_bottom') :
    $r('app.float.poweroff_option_land_scape_margin_bottom');
  }
  /**
   * 连接设置的serviceExtension
   */
  connectServiceAbility(): void {
    let that = this;
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote: rpc.IRemoteObject) {
        let option = new rpc.MessageOption();
        let data = rpc.MessageSequence.create();
        data.writeInterfaceToken(PowerOffStyleConstants.INTERFACE_TOKEN);
        let reply = rpc.MessageSequence.create();
        data.writeInt(1);
        data.writeString(PowerOffStyleConstants.SEND_POWER_OFF_CHECK_REMOTE);
        data.writeString(PowerOffStyleConstants.SEND_POWER_OFF_CHECK_REMOTE_NO_SELECT);
        remote.sendMessageRequest(1, data, reply, option)
          .then(result => {
            log.showWarn(TAG, `send message request result ${result.code}`);
            if (result.code === 1) {
              if (that.timer !== 0) {
                log.showInfo(TAG, `clearTimeout ${that.timer}`);
                clearTimeout(that.timer);
              }
              that.isFinished.resolve();
            }
          })
          .catch((error: BusinessError) => {
            log.showError(TAG, `connect setting service catch error ${error?.code} message ${error?.message}`);
          })
          .finally(() => {
            data.reclaim();
            reply.reclaim();
          });
      },
      onDisconnect(elementName) {
        log.showError(TAG, `disconnect to setting service`);
      },
      onFailed(code: number) {
        log.showError(TAG, `connect setting service failed ${code}`);
      }
    }
    try {
      log.showInfo(TAG, `connect to serviceExtension`);
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      const requestWant: Want = {
        bundleName: PowerOffStyleConstants.SETTING_SERVICE_BUNDLE_NAME,
        abilityName: PowerOffStyleConstants.SETTING_SERVICE_ABILITY_NAME
      };
      context.connectServiceExtensionAbility(requestWant, connectOption);
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `error ${err?.message}`);
    }
  }

  build() {
    // 关机界面
    Column() {
      Row().height(this.blankTopHeight)
      this.bodyContentSection()
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick((event) => {
      log.showWarn(TAG, `poweroff destroy ${this.currentMode}`);
      this.onChangeCurrentMode();
    })
    .accessibilityText(this.accessibilityBack)
  }

  /**
   * 计算字体最大放大倍数
   */
  private calcMaxFontScale(): void {
    try {
      // 获取按钮文本
      const rebootText: string = getContext(this).resourceManager.getStringSync($r('app.string.Poweroff_Button_Reboot'));
      const shutdownText: string = getContext(this).resourceManager.getStringSync($r('app.string.Poweroff_Button_Shutdown'));
      // 计算文本宽度，取重启和关机文本中占用宽度更大的进行计算
      const rebootTextWidth = Number(this.getMeasureTextSize(rebootText)?.width ?? 0);
      const shutdownTextWidth = Number(this.getMeasureTextSize(shutdownText)?.width ?? 0);
      const widerTextWidth = ArkUIAdapter.px2vp(Math.max(rebootTextWidth, shutdownTextWidth));

      //  获取文本宽度限制
      const maxTextWidth = this.getMaxTextWidth();
      const minTextWidth = this.getMinTextWidth();

      if (widerTextWidth > 0 && maxTextWidth > 0) {
        // 计算字体最大缩放比例
        this.maxFontScale = Math.min(maxTextWidth / widerTextWidth, PowerOffStyleConstants.POWEROFF_MAX_FONT_SCALE);
        // 当前字体缩放比例
        const curFontScale = Math.min(this.getFontScale(), this.maxFontScale);
        // 计算当前放大倍数下文本实际占用宽度，且不能超过最大宽度和小于最小宽度
        const textWidth = curFontScale * widerTextWidth;
        this.buttonAndTextWidth = Math.min(
          Math.max(textWidth, minTextWidth),
          maxTextWidth
        );
      }
      log.showInfo(TAG, `maxFontScale: ${this.maxFontScale}, buttonAndTextWidth: ${this.buttonAndTextWidth}`);
    } catch (err) {
      log.showError(TAG, 'calcMaxFontScale failed.', err);
    }
  }

  /**
   * 获取文本按钮容器最小宽度
   */
  private getMinTextWidth(): number {
    return this.buttonMinSpace + PowerOffStyleConstants.POWEROFF_BUTTON_SIZE -
    PowerOffStyleConstants.POWEROFF_TIPS_PADDING;
  }

  /**
   * 获取文本按钮容器最大宽度
   */
  private getMaxTextWidth(): number {
    let maxTextWidth = 0;
    try {
      const textPadding = PowerOffStyleConstants.POWEROFF_TIPS_PADDING * 3 / 2;
      const defaultDisplay = display.getDefaultDisplaySync();
      maxTextWidth = ArkUIAdapter.px2vp(defaultDisplay.width ?? 0) / 2 - textPadding;
    } catch (err) {
      log.showError(TAG, 'getMaxTextWidth failed.', err);
    }
    return maxTextWidth;
  }

  /**
   * 计算指定文本的宽度和高度
   */
  private getMeasureTextSize(textContent: string): SizeOptions {
    const measureUtils: MeasureUtils = ArkUIAdapter.getMeasureUtils(this.getUIContext());
    return measureUtils.measureTextSize({
      textContent: textContent,
      fontSize: `${textFontSize}vp`,
      fontWeight: FontWeight.Medium,
      fontFamily: 'HarmonyHeiTi',
      textAlign: TextAlign.Center,
    });
  }

  /**
   * 获取当前字体缩放倍数
   */
  private getFontScale(): number {
    let fontScale = 1;
    try {
      const scaleSize = systemParameterEnhance.getSync('persist.sys.font_scale_for_user0', '1');
      log.showInfo(TAG, `getFontScale value: ${scaleSize}`);
      if (!Number.isNaN(Number(scaleSize))) {
        fontScale = Number(scaleSize);
      }
    } catch (err) {
      log.error('getFontScale failed.', err);
    }
    return fontScale;
  }
}

@Component
struct RoundButtonAndText {
  @Prop @Watch('onModeChange') currentMode: Mode;

  @Prop icon: Resource;
  @Prop fontColor: Resource;
  @Prop accessibilityContent: Resource;
  @Prop accessibilityClickContent: Resource;
  @Prop columnTransition: TransitionEffect;
  @Prop handleClick: ClickEventHandler;
  @Prop normalStateText: Resource;
  @Prop activatingText: Resource;
  @Prop textColor: Resource;
  @Prop accessId: string;
  @Prop buttonAndTextWidth: Length;
  @Prop maxFontScale: number;
  @State scaleAttr: ScaleOptions = AnimationManager.INITIAL_SCALE_ANIMATION;
  @State textMargin: Length = AnimationManager.INITIAL_TEXT_MARGIN;
  @State textEffect: TransitionEffect = AnimationManager.TEXT_EFFECT_ANIMATION;
  @State clickTextEffect: TransitionEffect = AnimationManager.TEXT_FINAL_EFFECT_ANIMATION;
  @State @Watch('onButtonStateChange') buttonState: ButtonState = ButtonState.NORMAL;

  handleComponentAnimation(
    buttonState: ButtonState,
    scaleAttr: ScaleOptions,
    textMargin: Length,
    textEffect: TransitionEffect,
    clickTextEffect: TransitionEffect
  ) {
    animateTo(AnimationManager.CLICK_ANIMATION, () => {
      this.buttonState = buttonState;
      this.scaleAttr = scaleAttr;
      this.textMargin = textMargin;
    });
    this.textEffect = textEffect;
    this.clickTextEffect = clickTextEffect;
  }

  onModeChange() {
    if (this.currentMode === Mode.NORMAL) {
      this.handleComponentAnimation(
        ButtonState.NORMAL,
        AnimationManager.INITIAL_SCALE_ANIMATION,
        AnimationManager.INITIAL_TEXT_MARGIN,
        AnimationManager.TEXT_EFFECT_ANIMATION,
        AnimationManager.TEXT_FINAL_EFFECT_ANIMATION
      );
    }
  }

  // 无障碍模式下监听按钮状态
  onButtonStateChange(): void {
    if (this.buttonState === ButtonState.ACTIVATING && accessibility.isOpenAccessibilitySync()) {
      let focusId = ACCESS_ID_SHUTDOWN;
      if (this.currentMode === Mode.REBOOT_ACTIVATING) {
        focusId = ACCESS_ID_REBOOT;
      }
      setTimeout(() => {
        log.showInfo(TAG, `onButtonStateChange ${focusId}`);
        ResourceUtil.requestFocusAccessibility(focusId);
      }, DELAY_FOCUS);
    }
  }

  // 获取无障碍播报文本
  getAccessibilityText(): Resource {
    return this.buttonState === ButtonState.ACTIVATING ? this.accessibilityClickContent : this.accessibilityContent;
  }

  @Builder
  textSection() {
    Row() {
      if (this.buttonState === ButtonState.NORMAL) {
        Text(this.normalStateText)
          .textCommonStyle(this.textColor)
          .fontSize(textFontSize)
          .transition(this.textEffect)
          .maxFontScale(this.maxFontScale)
      }
      if (this.buttonState === ButtonState.ACTIVATING) {
        Text(this.activatingText)
          .textCommonStyle(this.textColor)
          .fontSize(textFontSize * PowerOffStyleConstants.POWEROFF_ANIMATION_SCALE)
          .transition(this.clickTextEffect)
          .maxFontScale(this.maxFontScale)
      }
    }
  }

  @Builder
  buttonSection() {
    Button({
      type: ButtonType.Circle,
      stateEffect: true
    }) {
      Image(this.icon)
        .objectFit(ImageFit.Contain)
        .height(PowerOffStyleConstants.POWEROFF_PIC_SIZE)
        .width(PowerOffStyleConstants.POWEROFF_PIC_SIZE)
        .scale(this.scaleAttr)
        .draggable(false)
    }
    .height(PowerOffStyleConstants.POWEROFF_BUTTON_SIZE)
    .width(PowerOffStyleConstants.POWEROFF_BUTTON_SIZE)
    .backgroundColor($r('app.color.poweroff_button_background_color'))
    .margin({ bottom: this.textMargin })
    .scale(this.scaleAttr)
    .onClick(() => {
      this.handleClick.handleClick();
      if (this.buttonState === ButtonState.NORMAL) {
        this.handleComponentAnimation(
          ButtonState.ACTIVATING,
          AnimationManager.SCALE_ANIMATION,
          AnimationManager.TEXT_MARGIN,
          AnimationManager.TEXT_FINAL_EFFECT_ANIMATION,
          AnimationManager.TEXT_EFFECT_ANIMATION
        );
      }
    })
    .onTouch((event: TouchEvent) => {
      event?.stopPropagation();
    })
    .accessibilityText(this.getAccessibilityText())
    .id(this.accessId)
  }

  build() {
    Column() {
      Row() {
        this.buttonSection()
      }
      this.textSection()
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .transition(this.columnTransition)
    .width(this.buttonState === ButtonState.ACTIVATING ? '100%' : this.buttonAndTextWidth)
  }
}

@Extend(Text)
function textCommonStyle(fontColor: Resource) {
  .fontFamily('HarmonyHeiTi')
  .fontWeight('Medium')
  .textAlign(TextAlign.Center)
  .height(PowerOffStyleConstants.POWEROFF_BUTTON_TEXT_FONT_HEIGHT)
  .fontColor(fontColor)
}
