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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import { FASlotName } from '@ohos/commonconstants';
import { PluginClickInfo, EventManager, EvtBus, ConfigurationEvent, sEventManager, GlobalContext } from '@ohos/frameworkwrapper';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { SubpageElementInfo } from '@ohos/systemuicommon/src/main/ets/template/newStyle/SubpageMenuViewData';
import { ControlSubpageContent } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ControlSubpageContent';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ToggleData } from '../../common/Constants';
import { UecPreloadUtil } from '../../common/UecPreloadUtil';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { display, performanceMonitor } from '@kit.ArkUI';
import { ScreenLockStatus } from '@ohos/screenlockcommon/src/main/ets/interface/ScreenOnOffMediator';
import { screenLock } from '@kit.BasicServicesKit';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';

const TAG: string = 'Ctrl.SubPageLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_ICON: string = TAG + '_AbilityComponent_';
const DEFAULT_WIDTH: number = 312;
const DEFAULT_HEIGHT: number = 398;
const DEFAULT_LANDSCAPE_HEIGHT: number = 312;
const DEFAULT_LANDSCAPE_MARGIN: number = 75;
const BORDER_RADIUS: number = 32;
const SINGLE_FOLD_SUB_HEIGHT: number = 276;
const SINGLE_FOLD_SUB_WIDTH: number = 276;
const SINGLE_FOLD_SUB_RADIUS: number = 20;
const toggleWhiteList: string[] = ['super_device', 'scenario_mode'];
const UEC_EXCEPTION_CODE: number = 100014;
const MAX_RETRY_TIME: number = 5;

/**
 * 外接开关二级页面
 *
 * @since 2024-02-17
 */
@Component
export struct SubPageLayout {
  /**
   * AbilityComponent组件包名
   */
  pluginBundleName: string = '';
  /**
   * AbilityComponent组件ability名
   */
  pluginAbilityName: string = '';
  /**
   * UIExtension的uiExtensionType
   */
  uiExtensionType: string = 'sys/commonUI';
  /**
   * 请求类型，业务自定义
   */
  requestType: number = -1;
  clickToggleSlot: string = '';
  private windowWidth: number = DEFAULT_WIDTH;
  private windowHeight: number | string | undefined = DEFAULT_HEIGHT;
  private uiExProxy: UIExtensionProxy | null = null;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private getSubColorState: boolean = false;
  private onRegisterState: boolean = false;
  private newSubPanelTextColor: number = 0;
  private landscapeWindowHeight: number = DEFAULT_LANDSCAPE_HEIGHT;
  private isSingleFoldMode: boolean = false;
  private subPageRadius: number = BORDER_RADIUS;
  private currentSubInfo?: SubpageElementInfo;
  @Link contentHeight: number | string;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @State isNeedTransition: boolean = true;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('QuickToggleData') toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
  private subPanelTextColor: number = 0;
  @Prop listHeight: number = 0;
  @State isShowExtension: boolean = true;
  @State retryNumber: number = 0;
  @Consume subpageOpacity : number;

  private onBlankAreaTouch(event?: TouchEvent): void {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      if (this.clickToggleSlot === FASlotName.WIFI_UI_EXTENSION) {
        performanceMonitor.begin('EXIT_CC_SUB_WIFI_ANI', performanceMonitor.ActionType.LAST_UP);
      } else if (this.clickToggleSlot === FASlotName.BLUETOOTH_UI_EXTENSION) {
        performanceMonitor.begin('EXIT_CC_SUB_BLUETOOTH_ANI', performanceMonitor.ActionType.LAST_UP);
      }
      sToggleSubWindowController.hideWindow();
    }
  }

  /**
   * 预加载UIExtensionAbility
   */
  private preloadUIExtension(want: Want): void {
    // 只在开启纯色模式的设备上生效预加载UEC
    if (this.colorModeViewData.isUseSolidColor()) {
      UecPreloadUtil.preloadUIExtensionAbility(want);
    }
  }

  aboutToAppear(): void {
    this.clickToggleSlot = sToggleSubWindowController.getCurrentSubPanelSlot();
    log.showInfo('aboutToAppear clickToggleSlot:' + this.clickToggleSlot);
    let clickInfo: PluginClickInfo = sToggleSubWindowController.getClickInfo(this.clickToggleSlot) as PluginClickInfo;
    if (!clickInfo) {
      clickInfo = sToggleSubWindowController.getCurrentClickInfo()!;
    }
    this.currentSubInfo = sToggleSubWindowController.getSubpageElementInfo();
    this.pluginBundleName = clickInfo?.bundleName;
    this.pluginAbilityName = clickInfo?.abilityName;
    this.preloadUIExtension({
      bundleName: this.pluginBundleName,
      abilityName: this.pluginAbilityName
    });
    if (clickInfo?.uiExtensionType) {
      this.uiExtensionType = clickInfo?.uiExtensionType;
    }
    this.requestType = clickInfo?.requestType;
    this.landscapeWindowHeight = this.getLandscapeWindowHeight();
    this.windowHeight = this.getSubWindowHeight(clickInfo);
    if (this.isSingleFoldMode) {
      this.initSingleFoldStyle();
    }
    try {
      this.subPanelTextColor = GlobalContext.getContext()
        .resourceManager
        .getColorSync($r('app.color.Control_center_subpanel_text_color').id);
    } catch (err) {
      log.error(`getColorSync failed: ${err.message}`);
    }

    if (screenLock.isLocked() && !ScreenLockAdapter.isInEdite()) {
      this.isShowExtension = false;
    } else {
      this.isShowExtension = true;
    }
    log.showInfo(`aboutToAppear this.isShowExtension: ${this.isShowExtension}`);
    // UIE加载锁屏状态监听
    sEventManager.subscribe('ControlCenterLockStatus', this.onLockStatusChanged);

    log.showInfo('slot:%{public}s, bundle:%{public}s, ability:%{public}s,' +
      ' type:%{public}s, height:%{public}d, requestType:%{public}d',
      this.clickToggleSlot,
      this.pluginBundleName,
      this.pluginAbilityName,
      this.uiExtensionType,
      this.windowHeight,
      this.requestType
    );
    this.eventMgr.on(ConfigurationEvent, this.handleConfigurationEvent);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear clickToggleSlot:' + this.clickToggleSlot);
    sEventManager.off('ControlCenterLockStatus', this.onLockStatusChanged);
    this.eventMgr.offAll();
    try {
      this.uiExProxy?.off('asyncReceiverRegister', this.proxyListener);
    } catch (err) {
      log.showError(`asyncReceiverRegister off failed, error message: ${err.message} `);
    };
    sToggleSubWindowController.clearSubpageInfo();
  }

  private onLockStatusChanged = (lockStatus: ScreenLockStatus): void => {
    log.showInfo(`onLockStatusChanged lock status: ${lockStatus}`);
    if (lockStatus === ScreenLockStatus.UNLOCK) {
      this.isShowExtension = true;
    } else {
      this.isShowExtension = false;
    }
    log.showInfo(`onLockStatusChanged this.isShowExtension: ${this.isShowExtension}`);
  }

  private initSingleFoldStyle(): void {
    this.windowWidth = SINGLE_FOLD_SUB_WIDTH;
    this.windowHeight = SINGLE_FOLD_SUB_HEIGHT;
    this.subPageRadius = SINGLE_FOLD_SUB_RADIUS;
  }

  build() {
    Stack() {
      Stack() {
      }.width('100%')
      .height('100%')
      .onTouch((event) => {
        this.onBlankAreaTouch(event);
      })
      .onClick(() => {
        if (StorageAdapter.getAccessibilityMode()) {
          sToggleSubWindowController.hideWindow();
        }
      })
      .accessibilityLevel('no')

      Stack() {
        Stack() {
        }.width('100%')
        .height('100%')
        .onTouch((event) => {
          this.onBlankAreaTouch(event);
        })
        .onClick(() => {
          if (StorageAdapter.getAccessibilityMode()) {
            sToggleSubWindowController.hideWindow();
          }
        })
        .accessibilityLevel('no')

        Column() {
          if (!CommonUtils.isEmpty(this.pluginBundleName) && !CommonUtils.isEmpty(this.pluginAbilityName)) {
            Column() {
              if (this.isShowExtension) {
                UIExtensionComponent({
                  bundleName: this.pluginBundleName,
                  abilityName: this.pluginAbilityName,
                  parameters: {
                    'ability.want.params.uiExtensionType': this.uiExtensionType,
                    'controlCenterSubPanelTextColor': this.subPanelTextColor,
                    'requestType': this.requestType,
                    'retryNumber': this.retryNumber,
                  }
                })
                .width('100%')
                .height('100%')
                .id(COMPONENT_ID_ICON + this.clickToggleSlot)
                .onTerminated((info) => {
                  log.showInfo('UIAbility terminal self, bundleName: ' + info?.want?.bundleName);
                })
                .onError((error) => {
                  log.showError(`The UEC is killed due to an exception, error code:${error?.code} msg:${error?.message}`);
                  if (error?.code === UEC_EXCEPTION_CODE && this.retryNumber < MAX_RETRY_TIME) {
                    this.retryNumber++;
                  }
                })
                .onReceive((data) => {
                  log.showInfo(`UIExtensionComponent onReceive`);
                  try {
                    if (!data) {
                      log.error(`invalid onReceive message`);
                      return;
                    }
                    let method: string = data['method'] as string ?? '';
                    log.showInfo(`onReceive data: ${method}`);
                    if (method == 'hideControlCenter') {
                      DropDownPanelManager.hideWindowDirectly();
                      return;
                    }
                    if (method == 'hideSubPage') {
                      sToggleSubWindowController.hideWindow();
                      return;
                    }
                  } catch (error) {
                    log.error('UIExtensionComponent onReceive error', error);
                  }
                })
                .onRemoteReady((proxy) => {
                  log.showInfo('onRemoteReady');
                  try {
                    if (this.uiExProxy) {
                      this.uiExProxy?.off('asyncReceiverRegister', this.proxyListener);
                      this.onRegisterState = false;
                    }
                    this.uiExProxy = proxy;
                    this.uiExProxy.on('asyncReceiverRegister', this.proxyListener);
                  } catch (err) {
                    log.showError(`asyncReceiverRegister on failed, error message: ${err.message} `);
                  };
                })
                .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
              }
            }
            .width(this.windowWidth)
            .height(this.windowHeight)
            .borderRadius(this.subPageRadius)
            .transition(TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 0.2, y: 0.2, centerX: '50%', centerY: '2%' })))
          } else if (this.currentSubInfo !== undefined) {
            Column() {
              ControlSubpageContent({
                titleIcon: this.currentSubInfo.titleIcon,
                titleText: this.currentSubInfo.titleText,
                domId: this.currentSubInfo.domId,
                menuList: this.currentSubInfo.menuList,
                onMenuItemClick: this.currentSubInfo.onMenuItemClick,
                onMoreSettingClick: this.currentSubInfo.onMoreSettingClick
              })
            }
            .width(this.windowWidth)
            .height(this.windowHeight)
            .borderRadius(this.subPageRadius)
            .transition(TransitionEffect.OPACITY.combine(TransitionEffect.scale({
              x: 0.2,
              y: 0.2,
              centerX: '50%',
              centerY: '30%'
            })))
          }
        }
        .width(this.windowWidth)
        .height(this.windowHeight)
        .borderRadius(this.subPageRadius)
        .backgroundColor(this.colorModeViewData.getSolidColor(
          this.colorModeViewData.subLayoutBgColor, this.colorModeViewData.mainCardTogOption))
        .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.mainCardTogOption))
        .clip(true)
        .geometryTransition(this.isNeedTransition ? this.getTransitionId() : '')
        .opacity(this.getOpacity())
        .onAppear(() => {
          animateTo({
            duration: 83,
            curve: Curve.Friction
          }, () => {
            this.subpageOpacity = 1;
          })
        })
        .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageMargin)
      }
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter ? '100%' : this.contentHeight)
      .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelMargin)
      .alignContent(Alignment.Center)
    }
    .direction(Direction.Ltr)
    // 设置该裁剪区域是为了解决收起二级页面动效结束前快速上滑列表导致胶囊超过列表区域造成动效异常
    .clip(new Rect({
      width: '100%',
      height: '100%'
    }).position({ x: 0, y: this.getPositionY() }))
    .width('100%')
    .height('100%')
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
  }

  private proxyListener = (proxy: UIExtensionProxy): void => {
    this.onRegisterState = true;
    if (this.getSubColorState) {
      proxy?.send({ 'controlCenterColor': this.newSubPanelTextColor });
      log.showInfo(`send color is ${this.newSubPanelTextColor}`);
    }
  }

  private getOpacity(): number {
    if (this.subpageOpacity === 1 && sToggleSubWindowController.getCurrentSubPanelSlot() !== this.clickToggleSlot) {
      return 0;
    }
    return this.subpageOpacity;
  }

  private getPositionY(): number {
    // 当是横屏或者列表无法滚动的时候不需要定制裁剪区域
    let shouldNotClip = this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ||
      this.contentHeight <= this.listHeight;
    // 90为头部区域加上下边距的高度
    let positionY = shouldNotClip ? 0 : 90;
    return positionY;
  }

  private getTransitionId(): string {
    if (this.toggleData.topToggle.includes(this.clickToggleSlot)) {
      log.showInfo('top toggles');
      return this.clickToggleSlot + CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showMediaAboveCardToggles;
    } else if (toggleWhiteList.includes(this.clickToggleSlot)) {
      log.showInfo('white list toggles');
      return this.clickToggleSlot + CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showMediaAboveCardToggles;
    } else {
      log.showInfo('normal toggles');
      return this.clickToggleSlot + (this.isSingleFoldMode ? '_singleFold' : '');
    }
  }

  private getSubWindowHeight(clickInfo: PluginClickInfo): string | number | undefined {
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      if (clickInfo?.windowHeight && clickInfo?.windowHeight < DEFAULT_LANDSCAPE_HEIGHT) {
        return clickInfo?.windowHeight;
      }
      return undefined;
    }
    return clickInfo?.windowHeight ?? CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageHeight;
  }

  private getLandscapeWindowHeight(): number {
    try {
      let curDisplay = display.getDefaultDisplaySync();
      if (curDisplay === undefined || curDisplay === null) {
        return DEFAULT_LANDSCAPE_HEIGHT;
      }
      let landscapeScreenHeight = curDisplay.orientation === display.Orientation.LANDSCAPE ||
        curDisplay.orientation === display.Orientation.LANDSCAPE_INVERTED ?
      px2vp(curDisplay.height) : px2vp(curDisplay.width);
      let landscapeWindowHeight = landscapeScreenHeight - DEFAULT_LANDSCAPE_MARGIN;
      return landscapeWindowHeight <= 0 ? DEFAULT_LANDSCAPE_HEIGHT : landscapeWindowHeight;
    } catch (e) {
      log.showError(`getLandscapeWindowHeight failed: ${e}`);
    }
    return DEFAULT_LANDSCAPE_HEIGHT;
  }

  private handleConfigurationEvent = (event: ConfigurationEvent | null): void => {
    try {
      this.newSubPanelTextColor = GlobalContext.getContext()?.resourceManager
        .getColorSync($r('app.color.Control_center_subpanel_text_color').id);
      log.showInfo(`get color is ${this.newSubPanelTextColor}`);
      if (this.newSubPanelTextColor !== this.subPanelTextColor) {
        this.getSubColorState = true;
      }
      if (this.getSubColorState && this.onRegisterState) {
          this.uiExProxy?.send({ 'controlCenterColor' : this.newSubPanelTextColor });
          log.showInfo(`send color is ${this.newSubPanelTextColor}`);
          this.getSubColorState = false;
      }
    } catch (err) {
      log.error(`get color is failed: ${err}`);
    }
  }
}