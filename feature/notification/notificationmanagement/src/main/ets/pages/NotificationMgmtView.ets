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

import { image } from '@kit.ImageKit';
import HeadComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import { NotificationMgmtViewData, ObservedArray,
  SlotViewData,
  VisualReminderConfig } from '../vm/NotificationMgmtViewData';
import { NotificationMgmtViewEvent } from '../vm/NotificationMgmtViewEvent';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper, fontScaleManager, FontScaleState } from '@ohos/managementcomponent';
import {
  LabelToggleView,
  PCEnableView,
  PCPinTopToggleView,
  SlotsView,
  VisualReminderView,
  AppNtfMgmtView
} from './NotificationMgmtCompments';
import { RemindType } from '../common/NotificationMgmtCommon';
import {
  PinTopLimitDialog,
  PinTopDialogOption
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { LengthMetrics } from '@ohos.arkui.node';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { SystemParameterUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SystemParameterUtil';
import SelectComponent from './SelectComponent';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { StatusBarModel } from '../model/StatusBarModel';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
import NtfConfigUtil from '../config/NtfConfigUtil';
import { HdsNavDestination, HdsNavDestinationAttribute } from '@kit.UIDesignKit';
import { SysUIHdsNavigations } from '../common/SysUIHdsNavigations';
import { PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';

const borderRadius: Length = '20vp';
const pcBorderRadius: Length = '16vp';
const containerBorder: BorderOptions =
  { color: $r('app.color.card_panel_bg'), radius: DeviceHelper.isPC() ? pcBorderRadius : borderRadius }

/* 页面标题 */
const pageTitle: Resource = $r('app.string.notifications');

const TAG = 'NotificationMgmt_View';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const MGMT_VIEW_BADGE_ICON_SIZE: number = 64;
const DEFAULT_BADGE_ICON_SIZE: number = 54;

@Entry
@Component
export struct NotificationMgmtView {
  // 解决 @Customer pinTopLimitDialogClose 报错问题（后期将PinTopLimitDialog中的变量删除后可删除）
  @Provide pinTopLimitDialogClose: boolean = true;
  appInfo: ESObject = {};
  private eventView: NotificationMgmtViewEvent = new NotificationMgmtViewEvent();
  private appIndex: number = 0;
  @State visualReminderConfigs: ObservedArray<VisualReminderConfig> = new ObservedArray();
  @State viewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  @StorageLink('navigationMode')
  @Watch('onNavModeChanged')
  navMode: number = AppStorage.get('navigationMode') ?? NavigationMode.Auto;
  @Watch('statusBarHeightChange') @State statusBarModel: StatusBarModel = StatusBarModel.get();
  @State contentPadding: LocalizedPadding = {
    start: this.navMode === NavigationMode.Split ? LengthMetrics.vp(24) : LengthMetrics.vp(16),
    end: this.navMode === NavigationMode.Split ? LengthMetrics.vp(24) : LengthMetrics.vp(16),
    top: DeviceHelper.isPC() ? LengthMetrics.vp(0) : LengthMetrics.vp(this.statusBarModel.height)
  };
  private pageInfos?: NavPathStack;

  @State appIcon: image.PixelMap | string | Resource | undefined = undefined;
  @State appTitle: string = '';
  // 应用内通知管理AbilityName
  @State appNtfMgmtAbilityName: string = '';
  @State transitionType: NavigationSystemTransitionType = NavigationSystemTransitionType.DEFAULT;
  // 长辈模式字体
  private fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  // 单个菜单按钮边距
  private singleMenuPadding: Padding = this.getMenuPadding();
  // 列表菜单按钮边距
  private listMenuPadding: Padding = this.getMenuPadding(0);
  private pageContext?: PageContext = PageStorages.getPageContext();

  aboutToAppear(): void {
    log.showInfo('AboutToAppear. appInfo: [%{public}s - %{public}s]', this.appInfo.appBundleName, this.appInfo.appUid);
    this.initEnv();
    this.appNtfMgmtAbilityName = this.viewData.getAppNtfMgmtAbilityName(this.appInfo.appBundleName);
    this.eventView.init(this.viewData, this.appInfo, this.buildPinTopExceededDialogController, this.pageInfos);
    this.eventView.initNavMode(this.navMode);
    this.contentPadding.top =
      this.viewData.isFromMainPage() || DeviceHelper.isPhoneOrPad() ? LengthMetrics.vp(0) : this.contentPadding.top;
    this.setVisualReminderConfigs();
    notificationSettingManager.subscribeChangeEvent(this.onConfigChange);
    this.appIcon = this.appInfo.appIcon;
    this.appTitle = this.appInfo.appTitle;
  }

  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear.');
    this.eventView.destroy();
    notificationSettingManager.unsubscribeChangeEvent(this.onConfigChange)
  }

  private initEnv(): void {
    this.setFromAppAndMeta();
    /* 逐级进入时 this.appInfo.appBundleName 不为空 */
    if (this.appInfo.appBundleName != null) {
      this.viewData.setFromMainPage();
      this.appIndex = this.appInfo.appIndex;
    } else {
      this.initEnvFromAbility();
    }

    this.setDestinationEntryType();
  }

  private setFromAppAndMeta(): void {
    if (this.pageContext) {
      log.showInfo('SetFromAppAndMeta %{public}s %{public}s', this.pageContext.isLaunch2SubPage,
        !this.pageContext.isFromHome);
      if (this.pageContext.isLaunch2SubPage && !this.pageContext.isFromHome) {
        this.viewData.setFromAppAndMeta();
      }
    } else {
      log.showWarn('SetFromAppAndMeta with null pageContext');
    }
  }

  private initEnvFromAbility() {
    log.showInfo('LoadAppInfoFromLocalStorage.');
    if (this.pageContext?.bundleInfo) {
      this.appInfo = this.pageContext.bundleInfo;
      this.appIndex = this.pageContext.appIndex ?? this.appIndex;
      log.showInfo('LoadAppInfoFromLocalStorage succeed.');
    } else {
      log.showWarn('LocalStorageParam or bundleInfo is none.');
    }
  }

  private async setVisualReminderConfigs(): Promise<void> {
    log.showInfo('setVisualReminderConfigs.');
    if (!DeviceHelper.isPC()) {
      this.visualReminderConfigs.push({
        label: $r('app.string.lock_screen_notification'),
        viewData: this.viewData.getScreenLockReminderViewData(),
        onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.LOCK_SCREEN, isOn)
      });
    }
    this.visualReminderConfigs.push({
      label: $r('app.string.banners'),
      viewData: this.viewData.getBannerReminderViewData(),
      onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.BANNER, isOn)
    });
    if (await notificationSettingManager.hasLauncher(this.appInfo?.['appBundleName'], this.appInfo?.['appUid'])) {
      this.visualReminderConfigs.push({
        label: $r('app.string.badges'),
        viewData: this.viewData.getCornerReminderViewData(),
        onChange: (isOn: boolean) => this.eventView.badgeStateChanged(isOn)
      });
    }
  }

  build() {
    if (DeviceHelper.isPC()) {
      this.buildPcDestination()
    } else {
      this.buildMobileDeviceDestination()
    }
  }

  @Builder
  buildMobileDeviceDestination() {
    // HdsNavDestination() {
    NavDestination() {
      this.buildContentView();
    }
    .hideTitleBar(false)
    .hideBackButton(false)
    // .titleBar(SysUIHdsNavigations.getTitleBarOptions(pageTitle))
    .title(pageTitle)
    .onShown(this.onDestinationShown)
    .systemTransition(this.transitionType)
    .onBackPressed(this.onDestinationBackPressed)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  private onDestinationShown = (): void => {
    if (this.pageContext?.isFromHome) {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    }

    /* 第一次进入是直接进入，返回主界面后再进入就不能算直接进入 */
    if (this.pageContext) {
      this.pageContext.isLaunch2SubPage = false;
    }
  }

  private onDestinationBackPressed = (): boolean => {
    log.showInfo('OnDestinationBackPressed. isHideBackButton: %{public}s', this.viewData.isHideBackButton());
    if (!this.viewData.isFromMainPage()) {
      PageStorages.popContext();
      return this.viewData.isHideBackButton();
    }
    return false;
  }

  private setDestinationEntryType(): void {
    log.showInfo('SetDestinationEntryType isLaunch2SubPage %{public}s', this.pageContext?.isLaunch2SubPage);
    if (this.pageContext?.isLaunch2SubPage) {
      this.transitionType = NavigationSystemTransitionType.TITLE;
    } else {
      this.transitionType = NavigationSystemTransitionType.DEFAULT;
    }
  }

  @Builder
  buildPcDestination() {
    if (this.viewData.isFromMainPage()) {
      NavDestination() {
        this.buildPCContentView();
      }
      .title(ResourceUtil.getStringSync(pageTitle) ?? '',
        {
          paddingStart: this.navMode === NavigationMode.Split && DeviceHelper.isPhoneOrPad() ? LengthMetrics.vp(24) :
          LengthMetrics.vp(16)
        })
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({ top: DeviceHelper.isPC() ? 4 : this.statusBarModel.height });
    } else {
      Column() {
        this.buildPageTitleView();
        this.buildPCContentView();
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding(0);
    }
  }

  @Builder
  buildContentView() {
    Row().height($r('app.float.page_title_height')).margin({ top: this.statusBarModel.height })
    Scroll() {
      Column() {
        this.buildBundleInfoView();
        this.buildEnableView();
        if (this.viewData.isOn()) {
          this.buildPinTopView();
          this.buildRemindersView();
          this.buildSlotsView();
          if (this.appNtfMgmtAbilityName) {
            this.buildAppNtfMgmtView();
          }
        }
      }
      .padding({ bottom: 36 })
    }
    .padding(this.contentPadding)
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: 200, curve: Curve.Sharp }), undefined))
  }

  @Builder
  buildPCContentView() {
    Scroll() {
      Column() {
        this.buildPCEnableView();
        if (this.viewData.isOn()) {
          this.buildPCPinTopView();
          this.buildRemindersView();
          this.buildSlotsView();
        }
      }
      .padding({ bottom: 36 })
    }
    .padding(this.contentPadding)
    .align(Alignment.Top)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }

  @Builder
  buildPCEnableView() {
    PCEnableView({
      appInfo: this.appInfo,
      state: this.viewData.getAllowState(),
      onChange: this.eventView?.allowStateChanged,
      isEnabled: this.viewData.isEnabled()
    })
  }

  @Builder
  buildPCPinTopView() {
    PCPinTopToggleView({
      state: this.viewData.getPinTopState(),
      onChange: this.eventView.pinTopStateChanged,
    })
  }

  @Builder
  buildPageTitleView() {
    HeadComponent({
      headName: pageTitle, hideBackButton: (this.viewData.isHideBackButton() &&
        !this.viewData.isFromAppAndMeta()), totalPadding: DeviceHelper.isPC() ? this.contentPadding : {}
    })
  }

  @Builder
  buildIconWithAppIndex() {
    AppIconWithIndexSubIcon({
      appIcon: this.appIcon,
      index: this.appIndex,
      compId: 'NotificationMgmtView_ICON_INDEX',
      compAlignRules: {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      },
      compMargin: undefined,
      appIconId: 'NotificationMgmtView_ICON',
      appIconSize: LengthMetrics.resource($r('app.float.appitem_notice_info_icon_width_l')).value,
      needShowBadgeIcon: false,
    })
  }

  @Builder
  buildBundleInfoView() {
    Row() {
      this.buildIconWithAppIndex()

      Column() {
        Text(this.appTitle)
          .id('NotificationMgmtView_BUNDLE_NAME')
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 4 })

        if (this.appInfo.appVersion && this.appInfo.appVersion.length > 0) {
          Text($r('app.string.version', this.appInfo.appVersion))
            .id('NotificationMgmtView_BUNDLE_VERSION')
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(2)
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Start)
        }
      }
      .margin({ start: LengthMetrics.vp(12) })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      end: LengthMetrics.vp(64)
    })
    .constraintSize({ minHeight: 96 })
    .width('100%')
  }

  @Builder
  buildEnableView() {
    LabelToggleView({
      label: $r('app.string.allowNotification'),
      state: this.viewData.getAllowState(),
      onChange: this.eventView?.allowStateChanged,
      isEnabled: this.viewData.isEnabled(),
      properties: {
        height: $r('app.float.switchComp_height'),
        bgColor: $r('sys.color.comp_background_list_card'),
        border: containerBorder,
        padding: this.singleMenuPadding
      }
    })
  }

  @Builder
  buildPinTopView() {
    if (this.viewData?.isNativeApp()) {
      LabelToggleView({
        label: $r('app.string.pinTopShowNotification'),
        state: this.viewData.getPinTopState(),
        onChange: this.eventView.pinTopStateChanged,
        properties: {
          margin: { top: $r('app.float.ntf_setting_item_margin') },
          height: $r('app.float.switchComp_height'),
          border: {
            width: $r('app.float.border_width'),
            color: $r('app.color.card_panel_bg'),
            radius: borderRadius
          },
          bgColor: $r('sys.color.comp_background_list_card'),
          padding: this.singleMenuPadding
        }
      })
    }
  }

  @Builder
  buildSilenceView() {
    LabelToggleView({
      label: $r('app.string.silent_notification'),
      state: this.viewData.getSilenceState(),
      onChange: this.eventView.silentStateChanged,
      properties: {
        height: $r('app.float.switchComp_height'),
        border: {
          width: $r('app.float.border_width'),
          color: $r('app.color.card_panel_bg'),
          radius: borderRadius
        },
        bgColor: $r('sys.color.comp_background_list_card')
      }
    })
    this.buildSilenceContentTxt();
  }

  @Builder
  buildSilenceContentTxt() {
    Row() {
      Text() {
        Span($r('app.string.silent_notification_description'))
      }
      .width('100%')
      .fontSize(12)
      .maxFontScale(2)
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Regular)
      .constraintSize({ minHeight: $r('app.float.ntf_hide_banner_txt_lineHeight') })
    }
    .margin({
      top: $r('app.float.ntf_hide_banner_txt_margin'),
      bottom: $r('app.float.title_text_margin_start')
    })
    .width('100%')
    .padding({
      left: $r('app.float.ntf_hide_banner_txt_padding'),
      right: $r('app.float.ntf_hide_banner_txt_padding')
    })
  }

  @Builder
  buildRemindersView() {
    Text($r('app.string.notification_style'))
      .draggable(false)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontSize($r('sys.float.ohos_id_text_size_body2'))
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi-Medium')
      .margin({
        start: LengthMetrics.vp(12),
        top: LengthMetrics.resource($r('app.float.reminder_view_title_margin_top')),
        bottom: LengthMetrics.vp(8)
      })
      .maxFontScale(2)
      .constraintSize({
        minHeight: 20
      })
      .alignSelf(ItemAlign.Start)

    this.buildSilenceView();
    this.buildVisualReminderViews()
    this.buildNonVisualReminderViews()
  }

  @Builder
  buildNonVisualReminderViews() {
    if (DeviceHelper.isPC()) {
      Column() {
        SelectComponent({
          title: $r('app.string.hide_banner_content_title'),
          opts: [$r('app.string.hide_banner_content_app_follow_system'),
            $r('app.string.hide_banner_content_app_always'),
            $r('app.string.hide_banner_content_app_never')],
          selectedIndex: this.viewData.getHideBannerContentReminder(),
          settingAction: this.eventView.hideBannerContentChanged,
        })
      }
      .margin({ top: 12 })
      .justifyContent(FlexAlign.Center)
      .border(containerBorder)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .constraintSize({
        minHeight: 48
      })
    }

    Column() {
      LabelToggleView({
        label: $r('app.string.remind_sound'),
        state: this.viewData.getSoundReminderState(),
        onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.SOUND, isOn),
        properties: { height: $r('app.float.label_toggle_view_height_single_line'), padding: this.listMenuPadding },
        silenceState: this.viewData.getSilenceState(),
      });

      if (!DeviceHelper.isPC() && SystemParameterUtil.IS_SUPPORT_VIBRATE) {
        Divider()
          .strokeWidth('1px')
          .color($r('sys.color.ohos_id_color_list_separator'))
          .margin({
            left: $r('app.float.switchComp_padding_r'),
            right: $r('app.float.switchComp_padding_r')
          });

        LabelToggleView({
          label: $r('app.string.ntfSoundModeOnlyVibration'),
          state: this.viewData.getVibrationReinderState(),
          onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.VIBRATION, isOn),
          properties: { height: 48, padding: this.listMenuPadding },
          silenceState: this.viewData.getSilenceState(),
        });
      }
    }
    .margin({ top: 12 })
    .padding({ top: $r('app.float.label_toggle_view_padding'), bottom: $r('app.float.label_toggle_view_padding') })
    .border(containerBorder)
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }

  @Builder
  buildVisualReminderViews() {
    VisualReminderView({
      remindConfigs: this.visualReminderConfigs,
      containerBorder: containerBorder,
      silenceState: this.viewData.getSilenceState(),
    })
  }

  @Builder
  buildSlotsView() {
    SlotsView({
      slots: this.viewData.getSlotsViewData(),
      properties: { border: containerBorder, padding: this.listMenuPadding },
      onSlotChange: this.eventView.slotStateChanged,
    })
  }

  @Builder
  buildAppNtfMgmtView() {
    AppNtfMgmtView({
      appName: this.appTitle,
      appNtfMgmtAbilityName: this.appNtfMgmtAbilityName,
      openAppNtfMgmt: this.eventView.openAppNtfMgmt,
      properties: { border: containerBorder, padding: this.singleMenuPadding }
    })
  }

  onNavModeChanged() {
    this.eventView.onNavModeChanged(this.navMode);
    this.updateContentPaddingByNavMode(this.navMode);
  }

  private updateContentPaddingByNavMode = (mode: NavigationMode) => {
    this.contentPadding.start = mode === NavigationMode.Split ? LengthMetrics.vp(24) : LengthMetrics.vp(16);
    this.contentPadding.end = mode === NavigationMode.Split ? LengthMetrics.vp(24) : LengthMetrics.vp(16);
  }
  private buildPinTopExceededDialogController = (option: PinTopDialogOption): CustomDialogController => {
    return new CustomDialogController({
      builder: PinTopLimitDialog({
        limit: option.limit,
        onSelected: option.onSelected,
        onCancel: option.onCancel,
        dialogWidth: NtfConfigUtil.dialogWidth,
        statusBarHeight: StatusBarModel.get().height,
        windowWidth: ContextManager.windowWidthByVp,
        windowHeight: ContextManager.windowHeightByVp
      }),
      autoCancel: false,
      alignment: NtfConfigUtil.alignment,
      showInSubWindow: NtfConfigUtil.showInSubWindow,
      customStyle: NtfConfigUtil.customStyle,
      width: NtfConfigUtil.dialogWidth,
      height: NtfConfigUtil.dialogHeight,
      cornerRadius: NtfConfigUtil.cornerRadius,
      backgroundBlurStyle: BlurStyle.NONE
    })
  };

  private async refreshAppConfig() {
    let bundleName: string = this.appInfo.appBundleName;
    log.showInfo(`refreshAppIcon bundleName: ${bundleName}, appIndex: ${this.appIndex}`);
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.equalTo({ bundle: bundleName, appIndex: this.appIndex });
    const configList = await NotificationConfigEntity.queryList(predicates, {
      columns: ['icon', 'label'],
    });
    if (configList && configList.length > 0) {
      this.appIcon = configList[0].icon;
      this.appTitle = configList[0].label;
    }
    this.appNtfMgmtAbilityName = this.viewData.getAppNtfMgmtAbilityName(this.appInfo.appBundleName);
  }

  private onConfigChange = (event: NotificationConfigEvent): void => {
    if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
      event.type === NotificationConfigEventType.UPDATE_ITEM) {
      this.refreshAppConfig();
    }
  }

  private statusBarHeightChange() {
    this.contentPadding.top = this.viewData.isFromMainPage() || DeviceHelper.isPhoneOrPad() ? LengthMetrics.vp(0) :
    LengthMetrics.vp(this.statusBarModel.height);
  }

  // 适老化布局，菜单按钮内边距取值 默认8vp；字体1.75倍以上16vp；字体2倍以上20vp
  private getMenuPadding(basePadding: number = 4): Padding {
    let paddingValue: number =
      this.fontScaleState.fontSizeScale < 1.75 ? 8 : (this.fontScaleState.fontSizeScale < 2 ? 16 : 20);
    return { top: paddingValue + basePadding, bottom: paddingValue + basePadding };
  }
}