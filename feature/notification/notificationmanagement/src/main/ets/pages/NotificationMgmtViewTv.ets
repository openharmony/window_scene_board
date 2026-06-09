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
import {
  NotificationMgmtViewData,
  ObservedArray,
  VisualReminderConfig,
  StateValue
} from '../vm/NotificationMgmtViewData';
import { NotificationMgmtViewEvent } from '../vm/NotificationMgmtViewEvent';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper } from '@ohos/managementcomponent';
import { RemindType, CommonProperties } from '../common/NotificationMgmtCommon';
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
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { PageContext } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import { StatusBarModel } from '../model/StatusBarModel';
import NtfConfigUtil from '../config/NtfConfigUtil';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'NotificationMgmt_View_Tv';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/* 页面标题 */
const pageTitle: Resource = $r('app.string.notifications');
const pageBgColor: Color | string = '#ff1a1a1a';
const borderRadius: Length = '16vp';
const borderColor: Color | string = '#26ffffff';
const cardBgColor: Color | string = '#19ffffff';
const toggleSelectedColor: Color | string = '#ff317af7';
const cardHeight: number = 64;
const titleTextColor: Color | string = '#e6ffffff';
const appTitleTextFontSize: number = 24;
const appTitleTextLineHeight: number = 32;
const viceTitleTextColor: Color | string = '#99ffffff';
const viceTitleTextFontSize: number = 22;
const viceTitleTextLineHeight: number = 29;
const versionTextHeight: number = 28;
const IS_INCLUDE_ABILITY_INFO = 33;
const paddingTop = 22;
const paddingBottom = 36;
const paddingLeft = 56;
const paddingRight = 56;

@Entry
@Component
export struct NotificationMgmtViewTv {
  // 解决 @Customer pinTopLimitDialogClose 报错问题（后期将PinTopLimitDialog中的变量删除后可删除）
  @Provide pinTopLimitDialogClose: boolean = true;
  private appInfo: ESObject = {};
  private eventView: NotificationMgmtViewEvent = new NotificationMgmtViewEvent();
  private appIndex: number = 0;
  @State visualReminderConfigs: ObservedArray<VisualReminderConfig> = new ObservedArray();
  @State viewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  @State contentPadding: LocalizedPadding = {
    top: LengthMetrics.vp(paddingTop)
  };
  private pageInfos?: NavPathStack;
  @State isAtomicService: boolean = false;
  @State appIcon: image.PixelMap | string | Resource | undefined = undefined;
  private pageContext?: PageContext = PageStorages.getPageContext();

  aboutToAppear(): void {
    log.showInfo('AboutToAppear. appInfo: [%{public}s - %{public}s]', this.appInfo.appBundleName, this.appInfo.appUid);
    this.initEnv();
    this.eventView.init(this.viewData, this.appInfo, this.buildPinTopExceededDialogController, this.pageInfos);
    notificationSettingManager.subscribeChangeEvent(this.onConfigChange);
    this.appIcon = this.appInfo.appIcon;
    bundleManager.getAppCloneBundleInfo(this.appInfo.appBundleName, this.appInfo.appIndex, IS_INCLUDE_ABILITY_INFO)
      .then((data) => {
        this.isAtomicService = data.appInfo?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE;
      });
  }

  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear.');
    this.eventView.destroy();
    notificationSettingManager.unsubscribeChangeEvent(this.onConfigChange)
  }

  private initEnv(): void {
    this.setFromAppAndMeta();
    if (this.appInfo.appBundleName != null) {
      this.viewData.setFromMainPage();
      this.appIndex = this.appInfo.appIndex;
      return;
    }
    this.initEnvFromAbility();
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

  build() {
    Column() {
      this.buildPageTitleView();
      this.buildContentView();
    }
    .backgroundColor(pageBgColor)
    .padding(this.contentPadding)
  }

  @Builder
  buildContentView() {
    Scroll() {
      Column() {
        this.buildBundleInfoView();
        this.buildEnableView();
        if (this.viewData.isOn() && !this.isAtomicService) {
          this.buildPinTopView();
          this.buildRemindersView();
        }
      }
      .padding({
        bottom: LengthMetrics.vp(paddingBottom),
        start: LengthMetrics.vp(paddingLeft),
        end: LengthMetrics.vp(paddingRight),
      })
    }
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(DeviceHelper.isPC() ? BarState.On : BarState.Off)
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  buildPageTitleView() {
    Row() {
      Text(pageTitle)
        .fontSize(32)
        .fontColor(titleTextColor)
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .lineHeight(43)
        .height(43)
        .margin({
          top: 21.5,
          bottom: 21.5
        })
    }
    .padding({
      start: LengthMetrics.vp(paddingLeft),
      end: LengthMetrics.vp(paddingRight)
    })
    .height(86)
    .width('100%')
  }

  @Builder
  buildIconWithAppIndex() {
    AppIconWithIndexSubIcon({
      appIcon: this.appIcon,
      index: this.appIndex,
      compId: 'NotificationMgmtViewTv_ICON_INDEX',
      compAlignRules: {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      },
      appIconId: 'NotificationMgmtViewTv_ICON',
      appIconSize: 86
    })
  }

  @Builder
  buildBundleInfoView() {
    Row() {
      this.buildIconWithAppIndex()
      Column() {
        Text(this.appInfo.appTitle)
          .id('NotificationMgmtViewTv_BUNDLE_NAME')
          .fontColor(titleTextColor)
          .fontSize(appTitleTextFontSize)
          .fontWeight(FontWeight.Medium)
          .lineHeight(appTitleTextLineHeight)
          .height(32)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 4 })
        if (this.appInfo.appVersion && this.appInfo.appVersion.length > 0) {
          Text($r('app.string.version', this.appInfo.appVersion))
            .id('NotificationMgmtViewTv_BUNDLE_VERSION')
            .fontColor(viceTitleTextColor)
            .fontSize(viceTitleTextFontSize)
            .fontWeight(FontWeight.Regular)
            .lineHeight(viceTitleTextLineHeight)
            .height(versionTextHeight)
            .textAlign(TextAlign.Start)
        }
      }
      .margin({ start: LengthMetrics.vp(22) })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      top: LengthMetrics.vp(16),
      end: LengthMetrics.vp(64)
    })
    .width('100%')
  }

  @Builder
  buildEnableView() {
    LabelToggleViewTv({
      label: $r('app.string.allowNotification'),
      state: this.viewData.getAllowState(),
      onChange: this.eventView?.allowStateChanged,
      properties: {
        margin: {
          top: 32
        },
        height: cardHeight,
        border: {
          width: $r('app.float.border_width'),
          color: borderColor,
          radius: borderRadius
        },
      }
    })
  }

  @Builder
  buildPinTopView() {
    if (this.viewData?.isNativeApp()) {
      LabelToggleViewTv({
        label: $r('app.string.pinTopShowNotification'),
        state: this.viewData.getPinTopState(),
        onChange: this.eventView.pinTopStateChanged,
        properties: {
          margin: {
            top: 16
          },
          height: cardHeight,
          border: {
            width: $r('app.float.border_width'),
            color: borderColor,
            radius: borderRadius
          },
        }
      })
    }
  }

  @Builder
  buildRemindersView() {
    Text($r('app.string.notification_style'))
      .draggable(false)
      .fontColor(viceTitleTextColor)
      .fontSize(viceTitleTextFontSize)
      .lineHeight(viceTitleTextLineHeight)
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi-Medium')
      .margin({
        start: LengthMetrics.vp(16),
        top: LengthMetrics.vp(41),
        bottom: LengthMetrics.vp(16)
      })
      .maxFontScale(2)
      .constraintSize({
        minHeight: 29
      })
      .alignSelf(ItemAlign.Start)

    LabelToggleViewTv({
      label: $r('app.string.banners'),
      state: this.viewData.getBannerReminderViewData(),
      onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.BANNER, isOn),
      properties: {
        height: cardHeight,
        border: {
          width: $r('app.float.border_width'),
          color: borderColor,
          radius: borderRadius
        },
      }
    })
  }

  private buildPinTopExceededDialogController = (option: PinTopDialogOption): CustomDialogController => {
    return new CustomDialogController({
      builder: PinTopLimitDialog({
        limit: option.limit,
        onSelected: option.onSelected,
        onCancel: option.onCancel,
        dialogWidth: NtfConfigUtil.dialogWidth,
        statusBarHeight: StatusBarModel.get().height,
        windowWidth: ContextManager.windowWidthByVp
      }),
      autoCancel: false,
      alignment: NtfConfigUtil.alignment,
      showInSubWindow: NtfConfigUtil.showInSubWindow,
      customStyle: true,
      backgroundBlurStyle: BlurStyle.NONE
    });
  }

  private async refreshAppIcon() {
    let bundleName: string = this.appInfo.appBundleName;
    log.showInfo(`refreshAppIcon bundleName: ${bundleName}, appIndex: ${this.appIndex}`);
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.equalTo({ bundle: bundleName, appIndex: this.appIndex });
    const configList = await NotificationConfigEntity.queryList(predicates, {
      columns: ['icon'],
    });
    if (configList && configList.length > 0) {
      this.appIcon = configList[0].icon;
    }
  }

  private onConfigChange = (event: NotificationConfigEvent): void => {
    if (event.type === NotificationConfigEventType.UPDATE_RESOURCE) {
      this.refreshAppIcon();
    }
  }
}

@Component
export struct LabelToggleViewTv {
  private label: ResourceStr = '';
  private onChange: (isOn: boolean) => void = (isOn: boolean) => {};
  private properties?: CommonProperties;
  private isEnabled: boolean = true;
  @ObjectLink state: StateValue;
  @State bgColor: Color | string = cardBgColor;
  @State isHover: boolean = false;

  build() {
    Row() {
      Row() {
        Text(this.label)
          .draggable(false)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize(24)
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .margin({
            start: LengthMetrics.vp(16),
          })
          .width('80%')
          // 企业设备黑名单应用，在置灰其通知开关的同时，将“允许通知”也置灰
          .opacity(this.isEnabled ? undefined : 0.4)

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.state.isOn() })
          .enabled(this.isEnabled)
          .selectedColor(toggleSelectedColor)
          .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .switchStyle({
            unselectedColor: $r('sys.color.ohos_id_color_component_normal')
          })
          .hoverEffect(HoverEffect.None)
          .width(48)
          .height(26)
          .margin({
            end: LengthMetrics.vp(16),
          })
          .onChange((isOn) => {
            log.showInfo('Toggle onChange data:%{public}s,current state:%{public}s', isOn, this.state.isOn());
            if (isOn === this.state.isOn()) {
              return;
            }
            this.state.setState(isOn);
            this.onChange(isOn);
          })
      }
      .constraintSize({ minHeight: this.properties?.height ?? 0 })
      .width(this.properties?.width ?? '100%')
      .backgroundColor(this.isHover ? cardBgColor : Color.Transparent)
      .border(this.properties?.border)
    }
    .scale({
      x: this.isHover ? 1.05 : 1.0,
      y: this.isHover ? 1.05 : 1.0,
    })
    .onHover((isHover?: boolean) => {
      if (isHover !== undefined) {
        this.isHover = isHover;
      }
    })
    .onClick(() => {
      this.state.setState(!this.state.isOn());
      this.onChange(this.state.isOn());
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width(this.properties?.width ?? '100%')
    .constraintSize({ minHeight: this.properties?.height ?? 0 })
    .margin(this.properties?.margin)
    .backgroundColor(this.bgColor)
    .borderRadius(borderRadius)
  }
}