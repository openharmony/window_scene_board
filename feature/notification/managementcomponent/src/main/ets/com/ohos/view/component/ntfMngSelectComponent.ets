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

import ConfigData from '../../common/constants';
import { LogDomain, LogHelper } from '../../common/BasicCommon';
import { DeviceHelper } from '../../common/DeviceHelper';
import { LengthMetrics } from '@ohos.arkui.node';
import { uiAppearance } from '@kit.ArkUI';
import { ToastType, ToastUtil } from '../../common/ToastUtil';

const TAG = 'ManagementComponent-ntfMngSelectComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_DESCRIBE = TAG + '_Text_describe';
const COMPONENT_ID_APP_SELECT = TAG + '_SELECT';
const itemBackgroundColor: ResourceColor = Color.Transparent;
const TOAST_CONTENT: string =
  getContext(this)?.resourceManager.getStringSync($r('app.string.display_lock_Screen_notification_content_tip'));

@Component
export default struct ntfMngSelectComponent {
  @State selectedIndex: number = 0;
  @State isShowMenu: boolean = false;
  @Prop isFacialUnlockEnabled?: boolean = false;
  private describe: string = '';
  private title: ResourceStr | string = '';
  private selectOptions: Resource[] = [];
  private initializationAction?: () => Promise<boolean>;
  private settingAction: (params: number) => void = () => {
  };
  private register?: (listener: (stateValue: boolean) => void) => void;
  private unRegister?: () => void;
  private registerListener = (stateValue: boolean) => {
    log.showInfo(`initState ${stateValue}`);
    this.selectedIndex = stateValue ? 0 : 1;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    if (this.register) {
      log.showInfo(`aboutToAppear register listener`);
      this.register(this.registerListener);
    }
    if (this.initializationAction) {
      this.initializationAction().then((data: boolean) => {
        log.showInfo(`initializationAction:${data}`);
        this.selectedIndex = data ? 0 : 1;
      });
    }
  }

  aboutToDisappear(): void {
    if (this.unRegister) {
      log.showInfo(`aboutToDisappear unregister listener`);
      this.unRegister();
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      this.buildSelectContent();
      this.buildSelectButton();
    }.width(ConfigData.WH_100_100)
    .border({
      color: Color.Transparent,
      radius: $r('app.float.border_radius')
    })
  }

  @Builder
  buildSelectContent() {
    Row() {
      Column() {
        Text(this.title)
          .draggable(false)
          .id(COMPONENT_ID_TITLE)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .align(Alignment.Start)
        Text(this.describe)
          .draggable(false)
          .id(COMPONENT_ID_DESCRIBE)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(2)
          .align(Alignment.Start)
          .margin({ top: $r('app.float.switchComp_text_margin') })
          .visibility((this.describe ? true : false) ? Visibility.Visible : Visibility.None)
      }.alignItems(HorizontalAlign.Start)
    }
    .margin({ start: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    .constraintSize(this.getHeight())
    .alignItems(VerticalAlign.Center)
    .layoutWeight(3)
  }

  @Builder
  buildSelectButton() {
    Row() {
      Flex({ direction: FlexDirection.RowReverse, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Row() {
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
            .fontSize(this.getScaledSize(14))
            .fontWeight(FontWeight.Normal)
            .fontColor([$r('sys.color.font_primary')])
        }
        .width(24)
        .height(24)
        .justifyContent(FlexAlign.Center)
        .bindContextMenu(this.isShowMenu, this.SelectMenu,
          { placement: Placement.BottomRight, offset: { x: 0, y: -8 },
            backgroundBlurStyle: BlurStyle.NONE,
            backgroundColor: $r('sys.color.comp_background_primary'),
          })

        Text(this.getButtonContent())
          .fontSize($r('sys.float.Body_M'))
          .maxFontScale(1.5)
          .fontWeight(FontWeight.Regular)
          .focusable(true)
          .fontColor($r('sys.color.font_secondary'))
          .textAlign(TextAlign.End)
          .stateStyles({
            normal: {
              .backgroundColor(itemBackgroundColor)
            }
          })
      }
      .width('100%')
      .constraintSize({ minHeight: 48 })
      .id(COMPONENT_ID_APP_SELECT)
    }
    .layoutWeight(2)
    .borderRadius(8)
    .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
    .margin({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    .onClick(() => {
      this.isShowMenu = !this.isShowMenu;
    })
    .stateStyles({
      normal: {
        .backgroundColor(itemBackgroundColor)
      }
    })
    .accessibilityRole(AccessibilityRoleType.SELECT)
  }

  @Builder
  SelectMenu() {
    Column() {
      ForEach(this.selectOptions, (_: Resource, index: number) => {
        SelectMenuItem({
          menuItemContent: this.selectOptions[index],
          index: index,
          isShowSymbolGlyph: this.getIsShowSymbolGlyph(index),
          settingAction: (index: number) => {
            this.settingAction(index);
            this.selectedIndex = index;
            this.isShowMenu = false;
          },
          isSelectMenuItemEnable: this.getIsSelectMenuItemEnable(index)
        })
        Divider()
          .color($r('sys.color.comp_divider'))
          .strokeWidth('1px')
          .padding({ left: $r('app.float.switchComp_padding_r'), right: $r('app.float.switchComp_padding_r') })
          .visibility(index === this.selectOptions.length - 1 ? Visibility.None : Visibility.Visible)
      })
    }
    .width($r('app.float.select_menu_item_width'))
  }

  private getHeight(): ConstraintSizeOptions {
    return this.describe ? { minHeight: $r('app.float.switchComp_height_double_text') } :
      { minHeight: $r('app.float.status_bar_switchComp_height') };
  }

  private getScaledSize(size: number): Length {
    const curScale = uiAppearance.getFontScale();
    return Math.min(curScale, 1.5) * size + 'vp';
  }

  private getIsSelectMenuItemEnable(index: number): boolean {
    if (this.selectOptions[index].id !== $r('app.string.display_only_when_the_owner_is_looking').id) {
      return true;
    }
    return this.isFacialUnlockEnabled ?? true;
  }

  private getButtonContent(): Resource {
    if (this.getIsSelectMenuItemEnable(this.selectedIndex)) {
      return this.selectOptions[this.selectedIndex];
    }
    return $r('app.string.always_display');
  }

  private getIsShowSymbolGlyph(index: number): boolean {
    return this.getButtonContent().id === this.selectOptions[index].id;
  }
}

@Component
struct SelectMenuItem {
  @Prop isShowSymbolGlyph: boolean;
  @Prop isSelectMenuItemEnable: boolean;
  menuItemContent: string | ResourceStr = '';
  index: number = 0;
  settingAction: (params: number) => void = () => {
  };

  build() {
    Row() {
      Text(this.menuItemContent)
        .fontSize($r('sys.float.Body_L'))
        .opacity(this.isSelectMenuItemEnable ? 1 : 0.4)
        .maxFontScale(2)
        .width('70%')

      SymbolGlyph($r('sys.symbol.checkmark'))
        .visibility(this.isShowSymbolGlyph ? Visibility.Visible : Visibility.Hidden)
        .fontSize(this.getSymbolScaledSize())
        .fontColor([$r('app.color.selected_icon_color')])
    }
    .width($r('app.float.select_menu_item_width'))
    .constraintSize({ minHeight: 48 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding({
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(12)
    })
    .stateStyles({
      normal: {
        .backgroundColor(itemBackgroundColor)
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
        .borderRadius($r('sys.float.corner_radius_level8'))
      },
      focused: {
        .backgroundColor(itemBackgroundColor)
        .borderRadius($r('sys.float.corner_radius_level8'))
      },
    })
    .onClick(() => {
      if (this.isSelectMenuItemEnable) {
        this.settingAction(this.index);
      } else {
        ToastUtil.showToast({
          message: TOAST_CONTENT,
          duration: 1500,
        }, ToastType.APP_NTF_CONFIG_HIDE_BANNER_CONTENT_FORBIDDEN);
      }
    })
    .accessibilityDescription(this.isSelectMenuItemEnable ? '' : TOAST_CONTENT)
    .accessibilitySelected(this.isShowSymbolGlyph)
    .accessibilityRole(AccessibilityRoleType.MENU_ITEM)
  }

  private getSymbolScaledSize(): string {
    const defaultL = 24;
    const curScale = uiAppearance.getFontScale();
    log.showWarn('getMarkScaledSize, %{public}d, curScale:%{public}d', defaultL, curScale);
    return Math.min(curScale, 2) * defaultL + 'vp';
  }
}