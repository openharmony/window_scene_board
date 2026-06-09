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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { AccessibilityUtil } from '../../accessibility/AccessibilityUtil';
import { ColorModeViewData } from './ColorModeViewData';
import { ColorModeViewModel } from './ColorModeViewModel';
import { MenuEntry } from './SubpageMenuViewData';

const TAG = 'Ctrl.ControlSubpageContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const MAX_FONT_SCALE: number = 1.5;
const DEFAULT_CACHE_COUNT = 3;

@Component
export struct ControlSubpageContent {
  public titleIcon?: ResourceStr | PixelMap;
  public titleText: ResourceStr = ''
  public domId: string = '';
  public onMoreSettingClick: () => void = () => {
  };
  public onMenuItemClick: (item: MenuEntry) => void = (item: MenuEntry) => {
  };
  public onDisappear: () => void = () => {
  };
  @State menuList: MenuEntry[] = [];
  private scroller: Scroller = new Scroller();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State itemBackgroundColor: ResourceColor = Color.Transparent;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.onDisappear();
  }

  build() {
    Column() {
      this.titleComponentBuilder()
      Scroll() {
        this.bondedDeviceListBuilder()
      }
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)

      this.MoreSettingButtonBuilder()
    }
    .size({ width: '100%', height: '100%' })
    .borderRadius('32vp')
  }

  @Styles
  normalStyles() {
    .backgroundColor(Color.Transparent)
  }

  @Styles
  pressedStyles() {
    .backgroundColor($r('sys.color.interactive_pressed'))
    .borderRadius('21vp')
  }

  @Styles
  itemPressedStyles() {
    .backgroundColor($r('sys.color.interactive_pressed'))
    .borderRadius('16vp')
  }

  @Builder
  bondedDeviceListBuilder() {
    if (this.menuList?.length > 0) {
      List({ scroller: this.scroller }) {
        ForEach(this.menuList, (item: MenuEntry) => {
          ControlSubpageItemComponent({
            menu: item,
            onMenuItemClick: this.onMenuItemClick
          });
        }, (item: MenuEntry) => {
          return JSON.stringify(item);
        });
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .cachedCount(DEFAULT_CACHE_COUNT)
      .divider({
        strokeWidth: px2vp(1),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: '60vp',
        endMargin: '24vp',
      })
      .alignSelf(ItemAlign.Start)
      .clip(true)
    }
  }

  /**
   * 控制中心二级页面-标题组件
   */
  @Builder
  titleComponentBuilder() {
    Column() {
      Column() {
        Image(this.titleIcon)
          .fillColor('$ohos:color:icon_primary')
          .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
            this.colorModeViewData.foregroundPrimaryOptionOnBackground))
          .size({
            width: '24vp',
            height: '24vp'
          })
          .draggable(false)
      }
      .margin({
        bottom: '8vp',
      })

      Text(this.titleText)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontColor($r('app.color.window_settings_font_primary'))
        .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.foregroundPrimaryOptionOnBackground))
        .lineHeight('27vp')
        .id(this.domId + '_title')
    }
    .width('100%')
    .padding({
      top: '16vp',
      bottom: '15vp'
    })
    .alignItems(HorizontalAlign.Center)
  }

  /**
   * 控制中心二级页面-更多设置
   */
  @Builder
  MoreSettingButtonBuilder() {
    Column() {
      Text($r('app.string.more_settings'))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Medium)
        .fontSize('16fp')
        .fontColor($r('app.color.control_center_sub_panel_settings_color'))
        .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.subpageMoreSettingsOption))
        .lineHeight('21fp')
        .width('100%')
        .textAlign(TextAlign.Center)
        .maxFontScale(MAX_FONT_SCALE)
    }
    .borderRadius('20vp')
    .backgroundColor(Color.Transparent)
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: '6vp',
      bottom: '16vp',
      left: '16vp',
      right: '16vp',
    })
    .padding({
      top: '10vp',
      bottom: '10vp',
    })
    .onClick(() => {
      this.onMoreSettingClick();
    })
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles
    })
  }
}

@Component
struct ControlSubpageItemComponent {
  @ObjectLink menu: MenuEntry;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State itemBackgroundColor: ResourceColor = Color.Transparent;
  private onMenuItemClick: (item: MenuEntry) => void = (item: MenuEntry) => {
  };

  @Styles
  normalStyles() {
    .backgroundColor(Color.Transparent)
  }

  @Styles
  itemPressedStyles() {
    .backgroundColor($r('sys.color.interactive_pressed'))
    .borderRadius('16vp')
  }

  private getAccessibilityText(accessibilityType: string): string {
    if (accessibilityType === 'text') {
      let result: string = this.menu.title + (this.menu.subTitle ?? '');
      return this.menu.isSelected ? result + ResUtils.getInnerString($r('app.string.selected')) :
        result + ResUtils.getInnerString($r('app.string.unselected'));
    }
    if (accessibilityType === 'description') {
      return this.menu.isSelected ? ' ' : '';
    }
    return '';
  }

  build() {
    ListItem() {
      Row() {
        Column() {
          Image(this.menu.icon as Resource)
            .size({ width: '24vp', height: '24vp' })
            .fillColor($r('sys.color.ohos_id_color_secondary'))
            .draggable(false)
        }

        Column() {
          Text(this.menu.title)
            .fontColor(this.menu.isSelected ? $r('app.color.control_center_sub_panel_selected_color') :
            $r('app.color.window_settings_font_secondary'))
            .fontSize('16fp')
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .lineHeight('22fp')
          if (this.menu.subTitle) {
            Text(this.menu.subTitle)
              .fontFamily('HarmonyHeiTi')
              .fontSize('14fp')
              .fontColor($r('app.color.window_settings_font_tertiary'))
              .fontWeight(FontWeight.Regular)
              .lineHeight('19fp')
              .textAlign(TextAlign.Start)
              .margin({
                top: '2vp',
              })
          }
        }
        .layoutWeight(1)
        .margin({
          left: '16vp',
          right: '9vp',
        })
        .padding({
          top: this.menu.subTitle ? '10vp' : '18vp',
          bottom: this.menu.subTitle ? '10vp' : '16vp',
        })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        if (this.menu.isSelected) {
          Column() {
            Image($r('app.media.ic_selected'))
              .fillColor($r('app.color.control_center_sub_panel_selected_color'))
              .size({
                width: '18vp',
                height: '18vp',
              })
              .draggable(false)
          }
        }
      }
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText(this.getAccessibilityText('text'))
      .accessibilityDescription(this.getAccessibilityText('description'))
      .width('100%')
      .padding({
        left: '8vp',
        right: '8vp',
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius('16vp')
      .backgroundColor(this.itemBackgroundColor)
      .onHover((isHover?: boolean) => {
        this.itemBackgroundColor = isHover ? $r('sys.color.interactive_hover') : Color.Transparent;
      })
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.itemPressedStyles
      })
      .onClick(() => {
        log.showInfo('ListItem click ' + this.menu.subTitle);
        this.onMenuItemClick(this.menu);
        AccessibilityUtil.sendAccessibility(ResUtils.getInnerString($r('app.string.selected')));
      })
    }
    .padding({
      left: '8vp',
      right: '8vp',
    })
  }
}
