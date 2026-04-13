/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { LengthMetrics } from '@kit.ArkUI';
import { MenuInfo, CommonConstants, StyleConstants } from '@ohos/launchercommon';
import { MenuCommonUtil } from '@ohos/launchercommon/Index';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { HorizontalMenuViewData } from '../viewmodel/HorizontalMenuViewData';
import { HorizontalMenuItemEvent } from '../viewmodel/HorizontalMenuItemEvent';

const TAG: string = 'FormStackMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct FormStackMenu {
  private readonly cardMenuInfoList: Array<MenuInfo> = [];
  private readonly formStackMenuInfoList: Array<MenuInfo> = [];
  private cardFixedMenuList: Array<MenuInfo> = [];
  private cardDynamicMenuList: Array<MenuInfo> = [];
  private formStackFixedMenuList: Array<MenuInfo> = [];
  private formStackDynamicMenuList: Array<MenuInfo> = [];
  private menuPlacement: Placement = Placement.BottomLeft;
  private readonly closeMenu: () => void = () => {};
  private isOuterDesktop: boolean = false;
  private menuWidth: number = StyleConstants.CONTEXT_FORM_MENU_WIDTH;
  private outerMenuWidth: number = StyleConstants.OUTER_STACK_MENU_WIDTH;
  aboutToAppear() {
    log.showInfo('aboutToAppear start');
    this.cardFixedMenuList = [];
    this.cardDynamicMenuList = [];
    for (let menuInfo of this.cardMenuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        this.cardFixedMenuList.push(menuInfo);
      } else {
        this.cardDynamicMenuList.push(menuInfo);
      }
    }

    this.formStackFixedMenuList = [];
    this.formStackDynamicMenuList = [];
    for (let menuInfo of this.formStackMenuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        this.formStackFixedMenuList.push(menuInfo);
      } else {
        this.formStackDynamicMenuList.push(menuInfo);
      }
    }
    if (this.isOuterDesktop) {
      this.menuWidth = StyleConstants.OUTER_CONTEXT_FORM_MENU_WIDTH;
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    this.cardFixedMenuList = [];
    this.cardDynamicMenuList = [];
    this.formStackFixedMenuList = [];
    this.formStackDynamicMenuList = [];
  }

  @Builder MenuBuilder(menuTop: MenuInfo[], menuDown: MenuInfo[], marginBottom: number, isNeedDivider: boolean) {
    Menu() {
      this.MenuItemBuilder(menuTop, isNeedDivider)
      this.MenuItemBuilder(menuDown, isNeedDivider)
    }
    .margin({bottom: marginBottom})
    .padding(StyleConstants.DEFAULT_4)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, { policy: 1 }, { disableSystemAdaptation: true })
    .borderRadius(StyleConstants.MENU_EXTERNAL_RADIUS)
  }

  @Builder MenuItemBuilder(menuInfoList: MenuInfo[], isNeedDivider: boolean) {
    ForEach(menuInfoList, (item: MenuInfo, index: number) => {
      MenuItem() {
        Column() {
          HorizontalMenuItem({
            mMenuInfo: item,
            mCloseMenuCb: this.closeMenu,
            mMenuWidth: this.menuWidth
          })
          if (index !== menuInfoList.length - 1 && isNeedDivider) {
            Divider()
              .color($r('sys.color.ohos_id_color_list_separator'))
              .strokeWidth('1px')
              .margin({
                start: LengthMetrics.vp(StyleConstants.DEFAULT_44),
                end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
              })
          }
        }
        .width(this.menuWidth)
      }
    }, (item: MenuInfo) => JSON.stringify(item.menuText))
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}) {
      if (MenuCommonUtil.isShowBottom(this.menuPlacement)) {
        this.MenuBuilder(this.cardDynamicMenuList, this.cardFixedMenuList, StyleConstants.DEFAULT_8, true)
        this.MenuBuilder(this.formStackDynamicMenuList, this.formStackFixedMenuList, StyleConstants.DEFAULT_0, false)
      } else {
        this.MenuBuilder(this.formStackFixedMenuList.reverse(), this.formStackDynamicMenuList.reverse(),
          StyleConstants.DEFAULT_8, false)
        this.MenuBuilder(this.cardFixedMenuList.reverse(), this.cardDynamicMenuList.reverse(),
          StyleConstants.DEFAULT_0, true)
      }
    }
    .width(this.isOuterDesktop ? this.outerMenuWidth : StyleConstants.FORM_MENU_WIDTH)
    .height('auto')
    .visibility((this.cardFixedMenuList.length > 0) || (this.formStackFixedMenuList.length > 0) ?
      Visibility.Visible : Visibility.None)
  }
}

@Component
struct HorizontalMenuItem {
  private readonly mCloseMenuCb: () => void = () => {};
  private readonly mMenuInfo: MenuInfo = new MenuInfo();
  private readonly mMenuWidth: number = 0;
  private readonly mEvent: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
  @State mViewData: HorizontalMenuViewData = new HorizontalMenuViewData();

  public aboutToAppear(): void {
    this.mEvent.initData(this.mViewData, this.mMenuInfo, this.mCloseMenuCb);
    this.mEvent.updateIcon();
    this.mEvent.updateShortcutName();
  }

  build() {
    Row() {
      Image(this.mViewData.mShortcutIcon).draggable(false)
        .objectFit(ImageFit.Contain)
        .height(StyleConstants.MENU_IMAGE_HEIGHT_PHONE)
        .width(StyleConstants.MENU_IMAGE_WIDTH_PHONE)
        .fillColor($r('sys.color.ohos_id_color_secondary'))
        .id(`${TAG}_Image_shortcutIcon`)
        .flexShrink(0)

      Text(this.mViewData.mShortcutName).draggable(false)
        .id(`${TAG}_Text_shortcutName`)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontWeight(FontWeight.Regular)
        .flexGrow(StyleConstants.DEFAULT_1)
        .flexShrink(StyleConstants.DEFAULT_1)
        .margin({ start: LengthMetrics.vp(StyleConstants.DEFAULT_12) })
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
    }
    .id(`${TAG}_Row_parent`)
    .border({
      radius: StyleConstants.MENU_EXTERNAL_RADIUS - StyleConstants.DEFAULT_4
    })
    .padding({
      start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
      end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
      top: LengthMetrics.vp(StyleConstants.DEFAULT_4),
      bottom: LengthMetrics.vp(StyleConstants.DEFAULT_4),
    })
    .constraintSize({
      minHeight: StyleConstants.DEFAULT_44,
    })
    .width(this.mMenuWidth)
    .backgroundColor(this.mViewData.getItemBackgroundColor())
    .onClick(() => {
      this.mEvent.onClick();
    })
    .onHover((isHover: boolean) => {
      this.mEvent.onHover(isHover);
    })
    .onTouch((event: TouchEvent) => {
      this.mEvent.onTouch(event);
    })
    .onMouse((event: MouseEvent) => {
      this.mEvent.onMouse(event);
    })
  }
}
