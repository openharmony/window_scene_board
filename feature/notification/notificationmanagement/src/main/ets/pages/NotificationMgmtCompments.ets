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

import {
  ObservedArray,
  SlotViewData,
  StateValue,
  VisualReminderConfig,
  VisualReminderViewData
} from '../vm/NotificationMgmtViewData';
import { LogDomain, Logger } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { CommonProperties, getLabelBySlotType, SlotType } from '../common/NotificationMgmtCommon';
import { DeviceHelper } from '@ohos/managementcomponent';
import { LengthMetrics } from '@ohos.arkui.node';
import uiAppearance from '@ohos.uiAppearance';
import { ResourceUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ResourceUtil';
import { AccessibilityManager } from '../common/AccessibilityManager';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { ToastType, ToastUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ToastUtil';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';


const TAG = 'NotificationMgmt_Components';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

const emptyOnChanged = (isOn: boolean) => {
  log.showWarn(TAG, 'OnChanged is not init. isOn: [[%{public}s]', isOn);
}
const pcBorderRadius: Length = '16vp';

/**
 * 带标签的切换组件
 */
@Component
export struct LabelToggleView {
  private label: ResourceStr = '';
  private onChange: (isOn: boolean) => void = emptyOnChanged;
  private properties?: CommonProperties;
  private isEnabled: boolean = true;
  @ObjectLink state: StateValue;
  @Prop silenceState: StateValue | undefined = undefined;

  build() {
    Row() {
      Text(this.label)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .margin({
          start: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
        })
        .width('80%')
        // 企业设备黑名单应用，在置灰其通知开关的同时，将“允许通知”也置灰
        .opacity(this.isEnabled ? undefined : 0.4)

      Toggle({ type: ToggleType.Switch, isOn: this.state.isOn() && !this.silenceState?.isOn() })
        .enabled(this.isEnabled)
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .margin({
          end: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
        })
        .onChange((isOn) => {
          log.showInfo(TAG, `Toggle onChange: ${isOn}, state:${this.state?.isOn()}, silenceState:${this.silenceState?.isOn()}`);
          if (this.state.isOn() && this.silenceState?.isOn())  {
            if (isOn) {
              this.onChange(isOn);
            }
            return;
          }
          if (isOn === this.state.isOn()) {
            return;
          }
          this.state.setState(isOn);
          this.silenceState?.setState(!isOn);
          this.onChange(isOn);
        })
        .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
        .opacity(this.state.isInitialized() ? 1 : 0)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(this.properties?.width ?? '100%')
    .constraintSize({ minHeight: this.properties?.height ?? 0 })
    .border(this.properties?.border)
    .margin(this.properties?.margin)
    .backgroundColor(this.properties?.bgColor)
    .padding(this.properties?.padding)
  }
}

@Component
export struct PCPinTopToggleView {
  @ObjectLink state: StateValue;
  private onChange: (isOn: boolean) => void = emptyOnChanged;

  build() {
    Row() {
      Column() {
        Text($r('app.string.pinTopShowNotification'))
          .draggable(false)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Medium)
          .margin({
            start: LengthMetrics.resource($r('app.float.page_notice_info_label_margin')),
            top: LengthMetrics.resource($r('app.float.switchComp_text_margin'))
          })

        Text($r('app.string.notification_pin_on_top'))
          .draggable(false)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontWeight(FontWeight.Regular)
          .margin({
            start: LengthMetrics.resource($r('app.float.page_notice_info_label_margin')),
            top: LengthMetrics.resource($r('app.float.switchComp_text_margin'))
          })
      }
      .alignItems(HorizontalAlign.Start)
      .width('80%')

      Toggle({ type: ToggleType.Switch, isOn: this.state.isOn() })
        .selectedColor($r('sys.color.ohos_id_color_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .margin({
          end: LengthMetrics.resource($r('app.float.switchComp_padding_r'))
        })
        .onClick(() => {
          const targetState = !this.state.isOn();
          this.state.setState(targetState);
          this.onChange(targetState);
        })
        .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
        .opacity(this.state.isInitialized() ? 1 : 0)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .constraintSize({
      minHeight: '64vp'
    })
    .border({
      width: $r('app.float.border_width'),
      color: $r('app.color.card_panel_bg'),
      radius: pcBorderRadius
    })
    .backgroundColor($r('app.color.card_panel_bg'))
  }
}

@Component
export struct PCEnableView {
  private appInfo: ESObject = {};
  private onChange: (isOn: boolean) => void = emptyOnChanged;
  private isEnabled: boolean = true;
  @ObjectLink state: StateValue;

  @Builder
  buildIconWithAppIndex() {
    AppIconWithIndexSubIcon({
      appIcon: this.appInfo.appIcon,
      index: this.appInfo.appIndex,
      compId: 'NotificationMgmtView_ICON_INDEX',
      compAlignRules: {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      },
      appIconId: 'NotificationMgmtView_ICON',
      appIconSize: LengthMetrics.resource($r('app.float.appitem_manage_icon_width')).value
    })
  }

  build() {
    Row() {
      Row() {
        this.buildIconWithAppIndex();
        Column() {
          Text(this.appInfo.appTitle)
            .lineHeight(22)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .margin({ start: LengthMetrics.vp(8), top: LengthMetrics.vp(10) })
            .opacity(this.isEnabled ? undefined : 0.4)

          Text($r('app.string.allowNotification'))
            .lineHeight(19)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Start)
            .margin({ start: LengthMetrics.vp(8), bottom: LengthMetrics.vp(11) })
            .opacity(this.isEnabled ? undefined : 0.4)
        }
        .padding({
          top: $r('app.float.allow_notification_padding'),
          bottom: $r('app.float.allow_notification_padding')
        })
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }
      .padding({ start: LengthMetrics.vp(12), end: LengthMetrics.vp(16) })
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: this.state.isOn() })
        .selectedColor($r('sys.color.ohos_id_color_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .margin({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
        .onChange(this.onChange)
        .hoverEffect(HoverEffect.Auto)
        .enabled(this.getIsEnableChange())
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .constraintSize({ minHeight: 72 })
    .border({
      width: $r('app.float.border_width'),
      color: $r('app.color.card_panel_bg'),
      radius: pcBorderRadius
    })
    .margin({
      left: 24,
      right: 24,
      top: 8,
      bottom: 12
    })
    .backgroundColor($r('app.color.card_panel_bg'))
  }

  private getIsEnableChange(): boolean {
    const CLOCK_BUNDLE = 'com.ohos.clock';
    // PC时钟应用定制，通知使能开关置灰开启后不可关闭,如默认关闭也能打开
    return this.isEnabled ? this.appInfo.appBundleName !== CLOCK_BUNDLE || !this.state.isOn() : false;
  }
}

@Component
export struct VisualReminderViewItem {
  private label: ResourceStr = '';
  private onChange: (isOn: boolean) => void = emptyOnChanged;
  @ObjectLink silenceState: StateValue;
  @ObjectLink @Watch('onViewDataChanged') viewData: VisualReminderViewData;
  @Consume visualReminderImgWidth: Resource;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State visualReminderImg: Resource = this.viewData.getImg();

  build() {
    Column() {
      Image(this.visualReminderImg)
        .width(this.visualReminderImgWidth)
        .objectFit(ImageFit.Fill)
        .syncLoad(true)
        .draggable(false)

      Text(this.label)
        .draggable(false)
        .margin({
          top: this.getFontSize($r('app.float.ntf_visual_reminder_view_text_margin_top'), '12vp'),
        })
        .fontSize(this.getFontSize($r('app.float.ntf_visual_reminder_view_text_font_size'), '14vp'))
        .constraintSize({
          minHeight: this.getFontSize($r('app.float.ntf_visual_reminder_view_text_height'), '19vp'),
        })
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .align(Alignment.Top)
        .flexGrow(1)
        .width(88)

      Checkbox()
        .enabled(this.viewData.getTotalSwtich())
        .select(this.viewData.getTotalSwtich() && this.viewData.isOn() &&
          (ResourceUtil.getStringSync(this.label) !== ResourceUtil.getStringSync($r('app.string.badges')) ?
            !this.silenceState.isOn() : true))
        .selectedColor(this.viewData.isOn() ? $r('app.color.batch_modif_id_color_emphasize') :
        $r('sys.color.ohos_id_color_switch_bg_off'))
        .borderColor($r('sys.color.ohos_id_color_switch_outline_off'))
        .hoverEffect(HoverEffect.Auto)
        .opacity(this.viewData.isInitialized() ? 1 : 0)
        .onClick(this.onChangeWithAccessibility)
        .margin({
          top: this.getFontSize($r('app.float.ntf_visual_reminder_view_text_margin_bottom'), '6vp')
        })
    }
    .accessibilityGroup(true)
    .accessibilityText(this.isAccessibilityMode ? this.getAccessibility() : '')
    .width(this.visualReminderImgWidth)
    .onClick(this.onChangeWithAccessibility)
  }

  private getAccessibility = (): string => {
    return [
      ResourceUtil.getStringSync((this.viewData.isOn() && this.viewData.getTotalSwtich()) ? $r('app.string.check_box_selected') :
      $r('app.string.check_box_unchecked')),
      ResourceUtil.getStringSync(this.label) ?? ''
    ].join(' ');
  }

  private onChangeWithAccessibility = () => {
    if (ResourceUtil.getStringSync(this.label) === ResourceUtil.getStringSync($r('app.string.badges')) &&
      !this.viewData.getTotalSwtich()) {
      ToastUtil.showToast({
        message: $r('app.string.switch_badges_forbidden'),
        duration: 3500,
      }, ToastType.BADGES_FORBIDDEN);
      return;
    }
    const targetState = !this.viewData.isOn();
    this.onChange(targetState);
    if (this.isAccessibilityMode) {
      const abilityMessage = ResourceUtil.getStringSync(targetState ? $r('app.string.check_box_selected') :
      $r('app.string.check_box_unchecked'));
      AccessibilityManager.getInstance()?.sendAccessibility(abilityMessage);
    }
  }

  /**
   * 这里的资源同时存在于2in1, base目录下, 同一个id对应了多个值. Text组件对于这种情况暂时不支持maxFontScale, 这里是手动获取缩放倍数的临时方案
   * getStringSync()方法对这种情况也无法正确获取资源, 这里把资源从'xxvp'改成了'xx',去掉了单位'vp',以临时使用getNumber()方法.
   * 等Text组件对于同id对应多资源的情景适应完善后, 可以删除
   * @param res 待查询的资源
   * @param defaultValue 当获取出错时返回的默认值,这里使用string.json里的值
   * @returns
   */
  private getFontSize(res: Resource, defaultValue: string): Length {
    try {
      const fontSize: number = getContext(this).resourceManager.getNumber(res.id);
      const curScale = uiAppearance.getFontScale();
      log.showInfo(TAG, `fontSize:${fontSize}, curScale:${curScale}`);
      const ret = Math.min(curScale, 2) * fontSize + 'vp';
      return ret;
    } catch (err) {
      log.showError(TAG, `getFontSize error:${err.message}`);
    }
    return defaultValue;
  }

  private onViewDataChanged() {
    this.visualReminderImg = this.viewData.getImg();
  }
}

@Component
export struct VisualReminderView {
  @Provide visualReminderImgWidth: Resource = $r('app.float.app_ntf_visual_remind_style_img_width');
  @ObjectLink remindConfigs: ObservedArray<VisualReminderConfig>;
  @ObjectLink silenceState: StateValue;
  private containerBorder?: BorderOptions;
  private isHalfMode?: boolean;

  aboutToAppear(): void {
    log.showInfo(TAG, 'VisualReminderView aboutToAppear');
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Stretch,
      justifyContent: FlexAlign.SpaceEvenly
    }) {
      ForEach(this.remindConfigs, (cfg: VisualReminderConfig, _idx: number) => {
        VisualReminderViewItem({
          label: cfg.label,
          viewData: cfg.viewData,
          onChange: cfg.onChange,
          silenceState: this.silenceState,
        })
      })
    }
    .id('VISUAL_REMIND_COMPONENT')
    .padding({ top: $r('app.float.ntf_visual_reminder_top_padding'), bottom: 16 })
    .onSizeChange(this.onViewSizeChange)
    .border(this.containerBorder)
    .backgroundColor(this.isHalfMode ? $r('sys.color.ohos_id_color_card_bg') : $r('app.color.card_panel_bg'))
  }

  private onViewSizeChange: (oldValue: SizeOptions, newValue: SizeOptions) => void =
    (oldValue: SizeOptions, newValue: SizeOptions) => {
      if (DeviceHelper.isPad()) {
        if (this.isHalfMode) {
          this.visualReminderImgWidth = $r('app.float.app_ntf_visual_remind_style_img_width');
        } else {
          this.visualReminderImgWidth =
            DeviceHelper.isLandscape() ? $r('app.float.app_ntf_visual_remind_style_img_pad_landscape_width') :
            $r('app.float.app_ntf_visual_remind_style_img_width');
        }
        // 横屏悬浮窗下需要判断宽度
        const calculatedWidth = LengthMetrics.resource(this.visualReminderImgWidth).value * this.remindConfigs.length;
        const newWidth = newValue?.width?.valueOf() as number;
        if (newWidth && (calculatedWidth > newWidth) && this.isHalfMode) {
          this.visualReminderImgWidth = $r('app.float.app_ntf_visual_remind_style_img_width_halfMode');
        }
        if (newWidth && (calculatedWidth > newWidth) && !this.isHalfMode) {
          this.visualReminderImgWidth = $r('app.float.app_ntf_visual_remind_style_img_width');
        }
      }
    }
}

/**
 * 类别标签组
 */
@Component
export struct SlotsView {
  @ObjectLink slots: ObservedArray<SlotViewData>;
  private onSlotChange: (isOn: boolean, type: SlotType) => void = emptyOnChanged;
  private properties?: CommonProperties;

  build() {
    if (this.slots.length > 0) {
      Text($r('app.string.remind_type'))
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium')
        .margin({
          start: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
          top: LengthMetrics.vp(28),
          bottom: LengthMetrics.vp(8)
        })
        .maxFontScale(2)
        .constraintSize({
          minHeight: 20
        })
        .alignSelf(ItemAlign.Start)

      List() {
        ForEach(this.slots, (slotViewData: SlotViewData) => {
          SlotToggleView({
            viewData: slotViewData,
            onChange: (isOn: boolean) => this.onSlotChange(isOn, slotViewData.getType()),
            properties: { height: 64, padding: this.properties?.padding },
          })
        })
      }
      .scrollBar(BarState.Off)
      .padding({ top: 4, bottom: 4 })
      .divider({
        strokeWidth: $r('app.float.soundItemDivider'),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: $r('app.float.switchComp_padding_r'),
        endMargin: $r('app.float.switchComp_padding_r')
      })
      .border(this.properties?.border)
      .backgroundColor($r('sys.color.comp_background_list_card'))
    }
  }
}

/**
 * 类别标签组件
 */
@Component
export struct SlotToggleView {
  @ObjectLink viewData: SlotViewData;
  private onChange: (isOn: boolean) => void = emptyOnChanged;
  private properties?: CommonProperties;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Column() {
        Text(getLabelBySlotType(this.viewData.getType()))
          .id('SWITCHER_TITLE')
          .draggable(false)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(2)
          .constraintSize({ minHeight: 22 })
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({ bottom: this.getScaledSize(2) })
          .accessibilityLevel('no')

        Text(this.viewData.getSecLabel())
          .id('SWITCHER_SECONDARY_TITLE')
          .draggable(false)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .constraintSize({ minHeight: 19 })
          .textAlign(TextAlign.Start)
          .accessibilityLevel('no')
      }
      .margin({ start: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
      .padding({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
      .alignItems(HorizontalAlign.Start)
      .width('80%')

      Toggle({ type: ToggleType.Switch, isOn: this.viewData.isOn() })
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .margin({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
        .onChange((isOn) => {
          log.showInfo(TAG, 'Toggle onChange data: %{public}s', isOn);
          if (isOn === this.viewData.isOn()) {
            return;
          }
          this.onChange(isOn);
        })
        .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
        .opacity(this.viewData.isInitialized() ? 1 : 0)
    }
    .width(this.properties?.width)
    .constraintSize({ minHeight: 64 })
    .border(this.properties?.border)
    .margin(this.properties?.margin)
    .backgroundColor(this.properties?.bgColor)
    .padding(this.properties?.padding)
    .accessibilityDescription([ResourceUtil.getStringSync(getLabelBySlotType(this.viewData.getType())),
      ResourceUtil.getStringSync(this.viewData.getSecLabel())].join(' '))
  }

  private getScaledSize(size: number): Length {
    const curScale = uiAppearance.getFontScale();
    log.showInfo(TAG, `get constraint size, cur scale:${curScale}`);
    return Math.min(curScale, 2) * size;
  }
}

@Component
export struct AppNtfMgmtView {
  private appName: string = '';
  private appNtfMgmtAbilityName: string = '';
  private openAppNtfMgmt = (abilityName: string) => {};
  private properties?: CommonProperties;

  build() {
    Row() {
      Text(this.getAppNtfMgmtTitle())
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .margin({
          start: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
        })
        .width('80%')
      Image($r('app.media.open_app_mgmt'))
        .width('24vp')
        .height('24vp')
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .margin({ end: LengthMetrics.vp(13) })
        .accessibilityLevel('no')
        .matchTextDirection(true)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .constraintSize({ minHeight: $r('app.float.switchComp_height') })
    .border(this.properties?.border)
    .margin({ top: $r('app.float.ntf_setting_item_margin') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(this.properties?.padding)
    .onClick(() => {
      this.openAppNtfMgmt(this.appNtfMgmtAbilityName);
    })
  }

  private getAppNtfMgmtTitle() {
    return ContextManager.context.resourceManager.getStringSync($r('app.string.open_app_inner_ntf_mgmt').id, this.appName);
  }
}