/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
  MenuInfo,
  CommonConstants,
  StyleConstants,
  EventConstants,
  keyEventManager,
  GridLayoutItemInfo
} from '../../TsIndex';
import { LogDomain, LogHelper, singleManager, SingleContext } from '@ohos/basicutils';
import { GlobalContext, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { DragGridPosition } from '@ohos/componentdrag';
import { RightMenuViewModel } from '../viewmodel/RightMenuViewModel';
import { image } from '@kit.ImageKit';
import { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { HashMap } from '@kit.ArkTS';
// import { createCollaborationServiceMenuItems, CollaborationServiceFilter } from '@kit.ServiceCollaborationKit';
import { KeyCodeConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { PageDesktopViewModelForPC } from '../viewmodel/PageDesktopViewModelForPC';

const TAG = 'RightMenu';
const HEIGHT_ITEM = 40;
const WIDTH_ITEM = 160;
const PADDING_ITEM = 4;
const SUB_MENU_ICON_WIDTH = 56;
const PADDING_ARROW_RIGHT = 12;
const CLICK_DELAY: number = 300;
const REPORT_PULL_MENU: number = 0;
const MENU_KEY_OF_CREATE_FOLDER: string = 'KEY_CREATE_FILE';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct RightMenu {
  @State menuInfoList: MenuInfo[] = [];
  @Prop singleContext?: SingleContext;
  menuMode: number = CommonConstants.MENU_UI_MODE_LIGHT;
  private rightMenuViewModel: RightMenuViewModel = singleManager.get<RightMenuViewModel>(RightMenuViewModel, undefined);
  @State currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State focusItem: string = '';
  @State hoverState: boolean = false;
  @State pressState: boolean = false;
  private pressedColor: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  private separatorColor: ResourceColor = $r('sys.color.ohos_id_color_list_separator');
  private menuWidth: number = WIDTH_ITEM;
  private isClicked: boolean = false;
  private isDarkMode: boolean = false;
  private subMenuWidthMap: HashMap<MenuInfo, number> = new HashMap();
  private rightClickPosition: DragGridPosition = {column: -1, row: -1};
  private touchPostion?: Position;
  private target?: GridLayoutItemInfo;

  aboutToAppear() {
    HiSysEventUtil.reportDesktopRightMenu(REPORT_PULL_MENU);
    log.showInfo('aboutToAppear start');
    if (!this.target) { // target不为空说明是PC大文件夹的右键菜单，无需清空桌面选中态
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESET_ALL_SELECT_STATUS, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_CLEAR_SELECT_ITEMS, null);
    }
    this.rightMenuViewModel.setMenuShowStatus(true);
    AppStorage.setOrCreate('isLongPress', false);
    this.menuInfoList = this.rightMenuViewModel.getRightMenuInfoList();
    this.updateMenuWidth();
    this.rightMenuViewModel.registerKeyEvent();
    this.isDarkMode = GlobalContext.getContext()?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    log.showInfo(`aboutToAppear end isDarkMode ${this.isDarkMode}`);
  }

  @Builder
  subCreatMenu(subMenuList: Array<MenuInfo>, menuItem: MenuInfo) {
    if (subMenuList?.length > 0) {
      Menu() {
        ForEach(subMenuList, (item: MenuInfo) => {
          if (this.isSeparatorItem(item)) {
            this.separatorBuilder(this.subMenuWidthMap?.get(menuItem))
          } else if (item.menuKeyString !== MENU_KEY_OF_CREATE_FOLDER) {
            MenuItem(
              this.IconTextMenuItemBuilder(item?.menuText ?? '', item?.menuImgSrc ?? '',
                this.subMenuWidthMap?.get(menuItem)))
              .id(`${TAG}_${item.menuKeyString}`)
              .width(this.subMenuWidthMap?.get(menuItem))
              .onClick((event?: ClickEvent) => {
                if (this.isClicked) {
                  return;
                }
                this.isClicked = true;
                if (item?.onMenuClick) {
                  item?.onMenuClick(this.rightClickPosition.column, this.rightClickPosition.row,
                    PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() !==
                    CommonConstants.NO_KEYBOARD ?
                    PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() :
                    this.rightClickPosition.page,
                    this.target);
                }
                ContextMenu.close();
                localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
                setTimeout(() => {
                  this.isClicked = false;
                }, CLICK_DELAY);
              })
              .onTouch((event?: TouchEvent) => {
                this.handleOnTouch(event, item?.menuKeyString as string)
              })
              .menuItemStyles()
          } else {
            MenuItem({
              startIcon: item?.menuImgSrc  as ResourceStr,
              content: item?.menuText,
              labelInfo: item?.shortcutKeyTips
            })
              .id(`${TAG}_${item.menuKeyString}`)
              .width(this.subMenuWidthMap?.get(menuItem))
              .onClick((event?: ClickEvent) => {
                if (this.isClicked) {
                  return;
                }
                this.isClicked = true;
                if (item?.onMenuClick) {
                  item?.onMenuClick(this.rightClickPosition.column, this.rightClickPosition.row,
                    PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() !==
                    CommonConstants.NO_KEYBOARD ?
                    PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() :
                    this.rightClickPosition.page,
                    this.target);
                }
                ContextMenu.close();
                localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
                setTimeout(() => {
                  this.isClicked = false;
                }, CLICK_DELAY);
              })
              .onTouch((event?: TouchEvent) => {
                this.handleOnTouch(event, item?.menuKeyString as string)
              })
              .menuItemStyles()
          }
        }, (item: MenuInfo) => JSON.stringify(item))
      }
      .margin({
        top: Math.floor(vp2px(-StyleConstants.DEFAULT_1)) + 'px',
        bottom: Math.floor(vp2px(-StyleConstants.DEFAULT_1)) + 'px'
      })
    }
  }

  @Styles
  menuItemStyles() {
    .margin({
      top: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px',
      bottom: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px'
    })
    .height(Math.ceil(vp2px(HEIGHT_ITEM)) + 'px')
  }

  @Builder
  IconTextMenuItemBuilder(menuName: string | Resource, icon: string | Resource | image.PixelMap, menuWidth: number) {
    IconTextMenuItem({ menuName: menuName, icon: icon, menuWidth: menuWidth})
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    this.rightMenuViewModel.unRegisterKeyEvent();
    this.rightMenuViewModel.setMenuShowStatus(false);
  }

  private getBackgroundColor(content: string): ResourceColor {
    if (content !== this.focusItem) {
      return Color.Transparent;
    }
    if (this.pressState) {
      return this.pressedColor;
    } else {
      return Color.Transparent;
    }
  }

  getIcon(): SymbolGlyphModifier {
    return new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontColor([$r('sys.color.ohos_id_color_primary')]);
  }

  private handleOnTouch(event?: TouchEvent, menuKeyString?: string): void {
    if (event?.type === TouchType.Down) {
      this.focusItem = menuKeyString as string;
      this.pressState = true;
    }
    if (event?.type === TouchType.Up) {
      this.pressState = false;
    }
  }

  private isSeparatorItem(item: MenuInfo): boolean {
    return item?.menuKeyString === '-';
  }

  private isCollaborationItem(item: MenuInfo): boolean {
    return item?.menuKeyString === 'KEY_COLLABORATION';
  }

  @Builder separatorBuilder(separatorWidth?: number) {
    Divider()
      .vertical(false)
      .color(this.separatorColor)
      .strokeWidth(px2vp(1))
      .width(separatorWidth)
      .margin({
        top: StyleConstants.DEFAULT_4,
        bottom: StyleConstants.DEFAULT_4
      })
      .padding({
        start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
        end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
        top: Math.ceil(vp2px(StyleConstants.DEFAULT_3)) + 'px',
        bottom: Math.ceil(vp2px(StyleConstants.DEFAULT_3)) + 'px'
      })
  }

  @Builder
  menuItemBuilder(item: MenuInfo) {
    MenuItem(item.subMenuList?.length !== 0 ?
      {
        content: item.menuText,
        builder: (): void => {
          this.subCreatMenu(item.subMenuList, item)
        },
        symbolEndIcon: this.getIcon()
      } :
    {
      content: item.menuText,
      labelInfo: item.shortcutKeyTips
    })
      .borderRadius(StyleConstants.DEFAULT_4)
      .margin({
        top: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px',
        bottom: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px'
      })
      .id(`${TAG}_${item?.bundleName}`)
      .padding({
        right: PADDING_ARROW_RIGHT,
        left: StyleConstants.DEFAULT_11
      })
      .backgroundColor(this.getBackgroundColor(item?.menuKeyString as string))
      .height(Math.ceil(vp2px(HEIGHT_ITEM)) + 'px')
      .onClick((event?: ClickEvent) => {
        if (item?.onMenuClick) {
          item.onMenuClick(this.rightClickPosition.column, this.rightClickPosition.row, this.touchPostion,
            PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() !==
            CommonConstants.NO_KEYBOARD ?
            PageDesktopViewModelForPC.getInstance().getKeyBoardStatus() :
            this.rightClickPosition.page,
            this.target);
          ContextMenu.close();
        }
        localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      })
      .onTouch((event?: TouchEvent) => {
        this.handleOnTouch(event, item?.menuKeyString as string)
      })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Menu() {
        ForEach(this.menuInfoList, (item: MenuInfo) => {
          if (this.isSeparatorItem(item)) {
            this.separatorBuilder();
          } else if (this.isCollaborationItem(item)) {
            // createCollaborationServiceMenuItems([CollaborationServiceFilter.ALL]);
          } else {
            this.menuItemBuilder(item);
          }
        }, (item: MenuInfo, index): string => {
          return this.getForeachKey(item);
        })
      }
      .borderRadius(StyleConstants.DEFAULT_4)
      .outline({
        width: 1, color: this.isDarkMode ? '#66000000' : '#1a000000',
        radius: StyleConstants.DEFAULT_8
      })
      .border({ width: 1, color: '#33ffffff', radius: StyleConstants.DEFAULT_8 })
      .font({
        size:($r('sys.float.ohos_id_text_size_body1')),
        weight:FontWeight.Medium,
      })
      .width(this.menuWidth)
      .padding({
        bottom: Math.floor(vp2px(StyleConstants.DEFAULT_3)) + 'px',
        top: Math.floor(vp2px(StyleConstants.DEFAULT_3)) + 'px',
        left: StyleConstants.DEFAULT_4,
        right: StyleConstants.DEFAULT_4
      })
    }
    .onKeyEvent((event?: KeyEvent) => {
      log.showInfo(`right menu key event coming: ${event?.keyCode}, ${event?.type}`);
      if (!event || (event.keyCode !== KeyCodeConstants.KEYCODE_U && event.keyCode !== KeyCodeConstants.KEYCODE_R)) {
        log.showInfo(`right menu key do not respond to other key events`);
        return;
      }
      keyEventManager.dispatchKeyEvent(event, true);
    })
  }

  private updateMenuWidth(): void {
    log.showInfo('updateMenuWidth');
    for (const menuItem of this.menuInfoList) {
      if (!menuItem?.menuText) {
        continue;
      }
      let currItemWidth: number = this.rightMenuViewModel.getMenuWidthAdaptive(menuItem);
      if (currItemWidth > this.menuWidth) {
        // 菜单宽度在最小宽度和67%屏幕宽度(组件实现)之间自适应
        this.menuWidth = currItemWidth;
      }
      if (menuItem.subMenuList === undefined || !menuItem.subMenuList.length) {
        continue;
      }
      let tempWidth:number = WIDTH_ITEM - 2 * PADDING_ITEM;
      for (const subMenuItem of menuItem.subMenuList) {
        if (!subMenuItem?.menuText) {
          continue;
        }
        let currSubItemTextWidth: number =
          this.rightMenuViewModel.getMenuWidthAdaptive(subMenuItem) - StyleConstants.DEFAULT_32;
        if (currSubItemTextWidth + SUB_MENU_ICON_WIDTH > tempWidth) {
          tempWidth = currSubItemTextWidth + SUB_MENU_ICON_WIDTH;
        }
        this.subMenuWidthMap?.set(menuItem, tempWidth);
      }
    }
    log.showInfo(`menuWidth:${this.menuWidth}`);
  }

  private getForeachKey(item: MenuInfo): string {
    if (item?.menuKeyString === '-') {
      return item?.bundleName as string;
    } else {
      return item?.menuKeyString as string;
    }
  }
}

@Component
struct IconTextMenuItem {
  private menuName: string | Resource = '';
  private icon: string | Resource | image.PixelMap = '';
  private menuWidth: number = 0;
  @State isHover: boolean = false;
  @State isPress: boolean = false;

  build() {
    Row() {
      if (this.icon !== '') {
        Image(this.icon)
          .objectFit(ImageFit.Contain)
          .width(StyleConstants.DEFAULT_24)
          .height(StyleConstants.DEFAULT_24)
          .margin({
            start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
            end: LengthMetrics.vp(StyleConstants.DEFAULT_8)
          })
      }

      Text(this.menuName)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.ohos_id_color_primary'))
        .wordBreak(WordBreak.BREAK_ALL)
        .maxLines(StyleConstants.DEFAULT_1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width(this.icon !== '' ? this.menuWidth - SUB_MENU_ICON_WIDTH : this.menuWidth)
        .margin((this.icon !== '') ? 0 : { start: LengthMetrics.vp(StyleConstants.DEFAULT_12)} )
    }
    .width(this.menuWidth)
    .height(HEIGHT_ITEM)
    .borderRadius(StyleConstants.POPUP_MENU_HOVER_RADIUS)
    .backgroundColor(this.getItemBackgroundColor(this.isPress, this.isHover))
    .onHover((isHover?: boolean) => {
      if (isHover !== undefined) {
        this.isHover = isHover;
      }
    })
    .onTouch((event?: TouchEvent) => {
      if (event && (event.type === TouchType.Down)) {
        this.isPress = true;
      } else if (event && (event.type === TouchType.Up)) {
        this.isPress = false;
        this.isHover = false;
      }
    })
  }

  getItemBackgroundColor(isPress: boolean, isHover: boolean) {
    if (isPress) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (isHover) {
      return $r('sys.color.ohos_id_color_hover');
    } else {
      return Color.Transparent;
    }
  }
}

@Component
struct HorizontalMenuItem {
  @State hoverState: boolean = false;
  @State pressState: boolean = false;
  menuInfo: MenuInfo = new MenuInfo();
  menuMode: number = CommonConstants.MENU_UI_MODE_LIGHT;

  public aboutToAppear(): void {
    log.showInfo(`HorizontalMenuItem menu bundleName:${this.menuInfo.bundleName}`);
    if (!AppStorage.get<string>('isPopupShow')) {
      this.hoverState = false;
      this.pressState = false;
    }
  }

  getItemBackgroundColor() {
    if (this.pressState) {
      return $r('sys.color.ohos_id_color_click_effect');
    }
    if (this.hoverState) {
      return $r('sys.color.ohos_id_color_hover');
    }
    return $r('sys.color.ohos_id_color_subtab_bg');
  }

  private getMenuKey(): string {
    if (this.menuInfo?.bundleName) {
      return this.menuInfo?.bundleName;
    }
    return '';
  }

  build() {
    Row() {
      Flex({
        direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start
      }) {
        Text(this.menuInfo?.menuText)
          .draggable(false)
          .fontColor((this.menuMode == CommonConstants.MENU_UI_MODE_LIGHT) ? $r('sys.color.ohos_id_color_text_primary') : '#e5ffffff')
          .key(this.getMenuKey())
          .fontSize(StyleConstants.MENU_FONTSIZE)
          .fontWeight(FontWeight.Regular)
          .height(StyleConstants.DEFAULT_20)
          .margin({
            start: LengthMetrics.vp(StyleConstants.DEFAULT_12)
          })
          .textOverflow({overflow: TextOverflow.Ellipsis})
      }
    }
    .border({
      radius: StyleConstants.POPUP_MENU_HOVER_RADIUS
    })
    .height(StyleConstants.DEFAULT_44)
    .onClick((event?: ClickEvent) => {
      if (this.menuInfo?.onMenuClick) {
        this.menuInfo?.onMenuClick();
      }
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    })
    .backgroundColor(this.getItemBackgroundColor())
    .onHover((isHover?: boolean) => {
      this.hoverState = isHover as boolean;
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        this.pressState = true
      }
      if (event?.type === TouchType.Up) {
        this.pressState = false
      }
    })
  }
}