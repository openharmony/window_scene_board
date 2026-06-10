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

import router from '@ohos.router';
import {
  BaseStyle,
  DeviceUtil,
  DynamicLoader,
  EntryMenuStyle,
  HiSysEventUtil,
  ImageStyle,
  LogUtil,
  MenuController,
  PushParam,
  SettingsBaseMenu,
  Style,
  TextStyle,
  UiRefresher,
} from '@ohos/common';
import { DefaultEntryMenuStyle, EntryMenu, HomeEntryMenuStyle, PageTitleTextStyle, StateMenu } from '../menus/Menu';
import { AppStyle } from './BaseComponent';
import {
  DETAIL_INFO_ICON,
  MARGIN_16,
  MARGIN_8,
  WIFI_HILINK_ICON
} from '../utils/Consts';

const ENTER_INTERNAL_ENTRY: string = 'enter_internal_entry';
const RED_CIRCLE_SIZE: number = 6;
const RED_CIRCLE_OFFSET: number = 6;

@Extend(Image)
function imageStyle(imageStyle?: ImageStyle) {
  .width(imageStyle?.size?.width as Length)
  .height(imageStyle?.size?.height as Length)
  .constraintSize(imageStyle?.constraintSize)
  .padding(imageStyle?.padding ?? 0)
  .margin(imageStyle?.margin ?? 0)
  .borderRadius(imageStyle?.borderRadius ?? 12)
  .layoutWeight(imageStyle?.layoutWeight ?? 0)
  .objectFit(imageStyle?.imageFit ?? ImageFit.Contain)
  .opacity(imageStyle?.opacity ?? 1)
  .draggable(false)
}

@Extend(Text)
function textStyle(textStyle?: TextStyle) {
  .width(textStyle?.size?.width as Length)
  .height(textStyle?.size?.height as Length)
  .constraintSize(textStyle?.constraintSize)
  .padding(textStyle?.padding ?? 0)
  .margin(textStyle?.margin ?? 0)
  .layoutWeight(textStyle?.layoutWeight ?? 0)
  .fontColor(textStyle?.fontColor)
  .fontSize(textStyle?.font?.size as Length)
  .fontWeight(textStyle?.font?.weight)
  .fontFamily(textStyle?.font?.family as string | Resource)
  .fontStyle(textStyle?.font?.style)
  .textAlign(textStyle?.textAlign ?? TextAlign.Start)
  .textOverflow({ overflow: textStyle?.overflow ?? TextOverflow.Ellipsis })
  .maxLines(textStyle?.maxLines)
  .align(textStyle?.align)
  .backgroundColor(textStyle?.backgroundColor)
  .borderRadius(textStyle?.borderRadius as Length)
  .minFontSize((textStyle as PageTitleTextStyle)?.font?.minFontSize ?? textStyle?.font?.size as Length)
  .maxFontSize((textStyle as PageTitleTextStyle)?.font?.maxFontSize as ResourceStr ?? textStyle?.font?.size as Length)
  .opacity(textStyle?.opacity ?? 1)
  .lineHeight(textStyle?.lineHeight)
  .wordBreak(textStyle?.wordBreak)
}

@Styles
function normalStateIconStyles() {
  .backgroundColor(Color.Transparent)
  .borderRadius(0) //  ux规定普通状态边界半径默认值0
}

@Styles
function pressedStateIconStyles() {
  .backgroundColor((DeviceUtil.isDevicePhone() || DeviceUtil.isDevicePad()) ? $r('sys.color.ohos_id_color_click_effect') : null)
  .borderRadius($r('sys.float.ohos_id_corner_radius_notification'))
}

/*
 * 获取控件背景颜色
 * @param showSelectedBackColor boolean: 是否显示背景颜色
 * @param isSelected boolean: 当前是否选中
 * @param isHover boolean: 是否鼠标悬停状态
 *
 * @return ResourceColor 对应的背景色
 */
function getBackgroundColor(showSelectedBackColor: boolean, isSelected: boolean, isHover: boolean): ResourceColor {
  if ((DeviceUtil.isDevicePhone() || DeviceUtil.isDevicePad()) && isSelected) {
    return $r('app.color.color_default_white');
  }

  if (showSelectedBackColor) {
    if (isSelected) {
      return $r('app.color.color_1A000000_grey');
    }
  }
  if (isHover) {
    return $r('sys.color.ohos_id_color_hover');
  }
  return $r('app.color.color_default_white');
}

function getBackgroundPadding(style: Style | null, showSelectedBackColor: boolean): Padding {
  let leftPadding: Length = (style as HomeEntryMenuStyle)?.marginStatus && !showSelectedBackColor ? 0 : $r('app.float.wh_value_4');
  let topPadding = (style as HomeEntryMenuStyle)?.homeSpacing ?? 0;
  return { left: leftPadding, right: leftPadding, top: topPadding, bottom: topPadding };
}

/*
 * 是否需要响应按压效果
 */
function isRespondTouchEvent(menu: EntryMenu | null): boolean {
  return menu === null || !(menu instanceof StateMenu);
}

/*
 * 刷新鼠标悬停状态
 */
function updateHover(isHover: boolean, menu: EntryMenu | null, stateHover: boolean): boolean {
  return isRespondTouchEvent(menu) ? isHover : stateHover;
}

@Component
export struct TitleSummaryEntryComponent {
  tag: string = 'TitleSummaryEntryComponent : ';
  @Link menu: EntryMenu;
  style?: DefaultEntryMenuStyle;
  controller?: MenuController;
  @Link uiRefresher: UiRefresher;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State showSelectedBackColor: boolean = true;

  build() {
    Column() {
      Text(this.uiRefresher.refreshId ? this.menu?.title : this.menu?.title)
        .visibility((this.menu?.title) ? Visibility.Visible : Visibility.None)
        .textStyle(this.style?.title)
      Text(this.menu?.summary)
        .visibility((this.menu?.summary) || this.style?.summary?.visible ? Visibility.Visible : Visibility.None)
        .textStyle(this.style?.summary)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width(this.style?.rootContainer?.size?.width as Length)
    .constraintSize(this.style?.rootContainer?.constraintSize)
    .padding(this.style?.rootContainer?.padding ?? 0)
    .margin(this.style?.rootContainer?.margin ?? 0)
    .onTouch((event?: TouchEvent): void => {
      if (event) {
        this.onTouchEvent(event);
      }
    })
    .onHover((isHover) => {
      isHover = isHover ? true : false;
      this.isHover = updateHover(isHover, this.menu, this.isHover);
      this.controller?.handleHoverEvent(isHover);
    })
    .onMouse((event?: MouseEvent): void => {
      if (event) {
        this.onMouseEvent(event);
      }
    })
    .backgroundColor(this.uiRefresher.refreshId
      ? getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover)
      : getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover))
    .onAppear(() => {
      this.reset();
    })
    .onDisAppear(() => {
      this.reset();
    })
    .onClick(() => {
      this.onEntryClick();
    })
    .visibility(this.uiRefresher?.refreshId && this.uiRefresher.isVisible() ? Visibility.Visible : Visibility.None);
  }

  private onEntryClick(): void {
    if (this.controller && this.controller.onMenuClick()) {
      return;
    }
    if (this.menu.targetPageUrl) {
      router.push({
        url: this.menu.targetPageUrl,
      });
    }
  }

  private onTouchEvent(event: TouchEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  private onMouseEvent(event: MouseEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isSelected = true;
    } else if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
      this.isSelected = false;
    }
  }
}


@Component
export struct TitleSummaryImageEntryComponent {
  tag: string = 'TitleStateImageEntryComponent : ';
  @Link menu: EntryMenu;
  style: DefaultEntryMenuStyle | undefined;
  controller: MenuController | undefined;
  uiRefresher: UiRefresher = new UiRefresher();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  showSelectedBackColor: boolean = true;

  @Styles
  normalStateIconStyles() {
    .backgroundColor(Color.Transparent)
    .borderRadius(0)
  }

  @Styles
  pressedStateIconStyles() {
    .backgroundColor((DeviceUtil.isDevicePhone() || DeviceUtil.isDevicePad())
      ? $r('sys.color.ohos_id_color_click_effect') : null)
    .borderRadius((DeviceUtil.isDevicePhone() ? $r('sys.float.ohos_fa_corner_radius_list_card_bg') : $r('sys.float.ohos_id_corner_radius_notification')))
  }

  build() {
    Column() {
      Column() {
        Row() {
          Column() {
            Text(this.menu?.title)
              .visibility((this.menu?.title) ? Visibility.Visible : Visibility.None)
              .textStyle(this.style?.title)

            Text(this.uiRefresher?.refreshId ? this.menu?.summary : this.menu?.summary)
              .visibility((this.menu?.summary) || this.style?.summary?.visible ? Visibility.Visible : Visibility.None)
              .textStyle(this.style?.summary)
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)

          Image(this.menu?.stateIcon)
            .hoverEffect(null)
            .id(`entry_image_${this.menu?.key}`)
            .stateStyles({
              normal: normalStateIconStyles,
              pressed: pressedStateIconStyles,
            })
            .visibility((this.menu?.stateIcon) ? Visibility.Visible : Visibility.None)
            .imageStyle(this.style?.stateIcon)
            .fillColor($r('sys.color.ohos_id_color_secondary'))
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(this.style?.rootContainer?.size?.height)
        .width(this.style?.rootContainer?.size?.width)
        .constraintSize(this.style?.rootContainer?.constraintSize)
        .padding(this.style?.rootContainer?.padding ?? 0)
        .margin(this.style?.rootContainer?.margin ?? 0)
        .layoutWeight(this.style?.rootContainer?.layoutWeight ?? 0)
        .clip(this.style?.rootContainer?.clip)
        .borderRadius(this.style?.rootContainer?.borderRadius)
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
        .onHover((isHover) => {
          this.isHover = updateHover(isHover ?? false, this.menu, this.isHover);
          this.controller?.handleHoverEvent(isHover ?? false);
        })
        .onMouse((event?: MouseEvent): void => {
          if (event) {
            this.onMouseEvent(event);
          }
        })
        .onAppear(() => {
          this.reset();
        })
        .onDisAppear(() => {
          this.reset();
        })
        .onClick(() => {
          this.onEntryClick();
        })
        .stateStyles({
          normal: this.normalStateIconStyles,
          pressed: this.pressedStateIconStyles,
        })
      }
      .width('100%')
      .backgroundColor(this.uiRefresher.refreshId
        ? getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover)
        : getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover))
      .borderRadius($r('app.float.wh_value_12'))
    }
    .padding({
      left: $r('app.float.padding_4'),
      right: $r('app.float.padding_4'),
    });
  }

  private onEntryClick(): void {
    if (this.controller && this.controller.onMenuClick()) {
      return;
    }
  }

  private onTouchEvent(event: TouchEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  private onMouseEvent(event: MouseEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isSelected = true;
    } else if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
      this.isSelected = false;
    }
  }
}

@Component
export struct TitleSummaryImageWlanEntryComponent {
  tag: string = 'TitleStateImageEntryComponent : ';
  @Link menu: EntryMenu;
  style: DefaultEntryMenuStyle | undefined;
  controller: MenuController | undefined;
  uiRefresher: UiRefresher = new UiRefresher();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  showSelectedBackColor: boolean = true;

  @Styles
  normalStateIconStyles() {
    .backgroundColor(Color.Transparent)
    .borderRadius(0)
  }

  @Styles
  pressedStateIconStyles() {
    .backgroundColor((DeviceUtil.isDevicePhone() || DeviceUtil.isDevicePad())
      ? $r('sys.color.ohos_id_color_click_effect') : null)
    .borderRadius((DeviceUtil.isDevicePhone() ? $r('sys.float.ohos_fa_corner_radius_list_card_bg') : $r('sys.float.ohos_id_corner_radius_notification')))
  }

  build() {
    Column() {
      Column() {
        Row({ space: MARGIN_16 }) {
          Image(this.menu?.stateIcon)
            .hoverEffect(null)
            .id(`entry_image_${this.menu?.key}`)
            .stateStyles({
              normal: normalStateIconStyles,
              pressed: pressedStateIconStyles,
            })
            .visibility((this.menu?.stateIcon) ? Visibility.Visible : Visibility.None)
            .imageStyle(this.style?.stateIcon)
            .fillColor($r('sys.color.ohos_id_color_primary'))
            .draggable(false)

          Column() {
            Text(this.menu?.title)
              .visibility((this.menu?.title) ? Visibility.Visible : Visibility.None)
              .textStyle(this.style?.title)
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Text(this.uiRefresher?.refreshId ? this.menu?.summary : this.menu?.summary)
                .visibility((this.menu?.summary) || this.style?.summary?.visible ? Visibility.Visible : Visibility.None)
                .textStyle(this.style?.summary)
              Text(this.uiRefresher?.refreshId ? this.menu.state : this.menu.state)
                .visibility((this.menu?.summary) || this.style?.summary?.visible ? Visibility.Visible : Visibility.None)
                .textStyle(this.style?.summary)
            }
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onEntryClick();
          })

          WlanHilinkDetailEntryComponent({
            stateIconVisibility: (this.menu?.stateIcon) ? Visibility.Visible : Visibility.None,
            isHilink: this.menu?.isNeedShowIcon as boolean,
            controller: this.controller,
            menuKey: this.menu?.key,
          }).margin({ right: $r('app.float.margin_8') })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .height(this.style?.rootContainer?.size?.height)
        .width(this.style?.rootContainer?.size?.width)
        .constraintSize(this.style?.rootContainer?.constraintSize)
        .padding(this.style?.rootContainer?.padding ?? 0)
        .margin(this.style?.rootContainer?.margin ?? 0)
        .layoutWeight(this.style?.rootContainer?.layoutWeight ?? 0)
        .clip(this.style?.rootContainer?.clip)
        .borderRadius(this.style?.rootContainer?.borderRadius)
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
        .onHover((isHover) => {
          this.isHover = updateHover(isHover ?? false, this.menu, this.isHover);
          this.controller?.handleHoverEvent(isHover ?? false);
        })
        .onMouse((event?: MouseEvent): void => {
          if (event) {
            this.onMouseEvent(event);
          }
        })
        .onAppear(() => {
          this.reset();
        })
        .onDisAppear(() => {
          this.reset();
        })
        .stateStyles({
          normal: this.normalStateIconStyles,
          pressed: this.pressedStateIconStyles,
        })
      }
      .width('100%')
      .backgroundColor(this.uiRefresher.refreshId
        ? getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover)
        : getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover))
      .borderRadius($r('app.float.wh_value_12'))
    }
    .padding({
      left: $r('app.float.padding_4'),
      right: $r('app.float.padding_4'),
    });
  }

  private onEntryClick(): void {
    if (this.controller && this.controller.onMenuClick()) {
      return;
    }
  }

  private onTouchEvent(event: TouchEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  private onMouseEvent(event: MouseEvent): void {
    if (!isRespondTouchEvent(this.menu)) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isSelected = true;
    } else if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
      this.isSelected = false;
    }
  }
}

@Reusable
@Component
export struct ReusableAppMenuEntryComponent {
  tag: string = 'ReusableAppMenuEntryComponent : ';
  style: AppStyle | null = null;
  controller: MenuController | null = null;
  @State menu: SettingsBaseMenu | null = null;
  uiRefresher: UiRefresher | null = null;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State secondIsHover: boolean = false;
  @State isSecondSelected: boolean | null = null;
  @State showSelectedBackColor: boolean = true;
  @State pathInfos: NavPathStack | null = null;
  @State showIcon: Resource | null = null;
  @State showTitle: Resource | null = null;
  @State showSummary: Resource | null = null;
  @State showStateIcon: Resource | null = null;
  @StorageLink('tabChangeFlag') tabChangeFlag: number = 0;

  build() {
    Column() {
      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Image(this.showIcon)
            .visibility(Visibility.Visible)
            .imageStyle(this.style?.iconImage)
            .flexGrow(0)
            .flexShrink(0)
            .align(Alignment.Start)
            .id(`entry_image_${this.menu?.key}`)
            .autoResize(false)
            .interpolation(ImageInterpolation.Medium)
            .border(this.tabChangeFlag === 0 ? { width: '1px', color: '#3F808080' } : { width: 0 })
          Column() {
            Text(this.showTitle)
              .visibility(Visibility.Visible)
              .textStyle(this.style?.title)
            Text(this.showSummary as Resource)
              .visibility(Visibility.Visible)
              .textStyle(this.style?.summary)
          }
          .alignItems(HorizontalAlign.Start)
          .flexGrow(1)
          .flexShrink(this.style?.startFlexShrink ?? 0)
          .justifyContent(FlexAlign.Start)

          Image(this.showStateIcon)
            .id(`entry_image_${this.menu?.key}`)
            .stateStyles({
              normal: normalStateIconStyles,
              pressed: pressedStateIconStyles,
            })
            .imageStyle(this.style?.stateIcon)
            .visibility(Visibility.Visible)
            .flexShrink(this.style?.endFlexShrink ?? 0)
            .fillColor($r('sys.color.ohos_id_color_fourth'))
        }
        .height(this.style?.rootContainer?.size?.height as Length)
        .width(this.style?.rootContainer?.size?.width as Length)
        .constraintSize(this.style?.rootContainer?.constraintSize)
        .padding(this.style?.rootContainer?.padding ?? 0)
        .margin(this.style?.rootContainer?.margin ?? 0)
        .layoutWeight(this.style?.rootContainer?.layoutWeight ?? 0)
        .clip(this.style?.rootContainer?.clip)
        .borderRadius(this.style?.rootContainer?.borderRadius as Length)
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
        .onHover((isHover) => {
          isHover = isHover ? true : false;
          this.isHover = updateHover(isHover, this.menu as EntryMenu, this.isHover);
          this.controller?.handleHoverEvent(isHover);
        })
        .stateStyles({
          normal: normalStateIconStyles,
          pressed: pressedStateIconStyles,
        })
        .onMouse((event?: MouseEvent): void => {
          if (event) {
            this.onMouseEvent(event);
          }
        })
        .onAppear(() => {
          this.reset();
        })
        .onDisAppear(() => {
          this.reset();
        })
        .onClick(() => {
          this.onEntryClick();
        })
      }
      .width('100%')
      .backgroundColor(this.uiRefresher?.refreshId
        ? getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover)
        : getBackgroundColor(this.showSelectedBackColor, this.isSelected, this.isHover))
      .borderRadius($r('sys.float.ohos_id_corner_radius_card'))
    }
    .padding(getBackgroundPadding(this.style, this.showSelectedBackColor))
    .visibility(this.uiRefresher?.refreshId && this.uiRefresher.isVisible() ? Visibility.Visible : Visibility.None);
  }

  private onEntryClick(): void {
    if (this.controller && this.controller.onMenuClick()) {
      return;
    }
    if (this.menu?.targetPageUrl) {
      router.push({
        url: this.menu.targetPageUrl,
      });
    }
  }

  aboutToReuse(params: Record<string, Object>): void {
    this.showIcon = params.showIcon as Resource;
    this.showTitle = params.showTitle as Resource;
    this.showSummary = params.showSummary as Resource;
    this.showStateIcon = params.showStateIcon as Resource;
    this.controller = params.controller as MenuController;
  }

  private onMouseEvent(event: MouseEvent): void {
    if (!isRespondTouchEvent(this.menu as EntryMenu)) {
      return;
    }
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isSelected = true;
    } else if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
      this.isSelected = false;
    }
  }

  private onTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
    this.isSecondSelected = false;
    this.secondIsHover = false;
  }
}