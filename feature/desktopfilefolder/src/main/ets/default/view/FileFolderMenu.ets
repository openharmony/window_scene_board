/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { MenuInfo, StyleConstants, EventConstants } from '@ohos/launchercommon';
import { LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {localEventManager } from '@ohos/frameworkwrapper';
import { LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import FileFolderSecondaryMenu from './FileFolderSecondaryMenu';
import { MenuConstants } from '../common/FileFolderConstants';
import { FileFolderMenuViewModel } from '../viewmodel/FileFolderMenuViewModel';

const TAG = 'FileFolderMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件文件夹一级菜单
 */
@Component
export struct FileFolderMenu {
  @State menuInfoList: MenuInfo[] = [];
  @State menuWidth: number = MenuConstants.MENU_ITEM_MIN_WIDTH;
  private uri: string = '';
  private menuVM: FileFolderMenuViewModel = FileFolderMenuViewModel.getInstance();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start');
    this.menuWidth = Math.max(this.menuWidth, this.menuVM.getMaxMenuWidth(this.menuInfoList));
    AppStorage.setOrCreate('isLongPress', false);
    AppStorage.setOrCreate('isRightMenuShow', true);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear start');
    AppStorage.setOrCreate('isRightMenuShow', false);
  }

  private getForeachKey(item: MenuInfo): string {
    return item?.menuKeyString as string;
  }

  @Builder
  menuItemBuilder(item: MenuInfo, hasSubmenu: boolean = false) {
    MenuItem(
      hasSubmenu ? {
        content: item.menuText,
        symbolEndIcon: this.getIcon(),
        builder: (): void => this.subCreatMenu(item, item.menuKeyString)
      } :
        {
          content: item.menuText,
          labelInfo: item.shortcutKeyTips
        })
      .id(`RightMenuItem_${item.menuKeyString}`)
      .margin({
        top: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px',
        bottom: Math.ceil(vp2px(StyleConstants.DEFAULT_1)) + 'px'
      })
      .padding({
        right: MenuConstants.PADDING_ARROW_RIGHT,
        left: MenuConstants.PADDING_ARROW_LEFT
      })
      .height(MenuConstants.MENU_ITEM_HEIGHT)
      .onClick((event?: ClickEvent) => {
        if (hasSubmenu) {
          return;
        }
        if (item?.onMenuClick) {
          item?.onMenuClick();
        }
        ContextMenu.close();
        localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      })
  }

  private getIcon(): SymbolGlyphModifier {
    return new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontColor([$r('sys.color.ohos_id_color_primary')]);
  }

  @Builder
  separatorBuilder() {
    MenuSeparator()
  }

  build() {
    Menu() {
      ForEach(this.menuInfoList, (item: MenuInfo) => {
        if (this.menuVM.isSeparatorItem(item)) {
          this.separatorBuilder();
        } else {
          this.menuItemBuilder(item, this.menuVM.isHasSubMenu(MenuConstants.MENU_LEVEL_INDEX_CONFIG, item.menuKeyString ?? ''));
        }
      }, (item: MenuInfo, index): string => {
        return this.getForeachKey(item);
      })
    }
    .font({
      size:($r('sys.float.ohos_id_text_size_body1')),
      weight:FontWeight.Medium,
    })
    .width(this.menuWidth)
    .visibility(this.menuInfoList.length > 0 ? Visibility.Visible : Visibility.None)
    .padding({
      bottom: StyleConstants.DEFAULT_4,
      top: StyleConstants.DEFAULT_3,
      left: StyleConstants.DEFAULT_4,
      right: StyleConstants.DEFAULT_5
    })
    .pixelRound({
      start: PixelRoundCalcPolicy.FORCE_CEIL,
      top: PixelRoundCalcPolicy.FORCE_CEIL
    })
  }

  @Builder
  subCreatMenu(item: MenuInfo, menuKeyString: string) {
    FileFolderSecondaryMenu({
      menuKeyString: menuKeyString,
      uri: this.uri,
      firstMenuItem: item,
    })
  }
}

@Component
export struct MenuSeparator {
  private separatorColor: ResourceColor = MenuConstants.SEPARATOR_COLOR;

  build() {
    Divider()
      .vertical(false)
      .color(this.separatorColor)
      .strokeWidth(px2vp(1))
      .margin({
        start: LengthMetrics.vp(StyleConstants.DEFAULT_12),
        end: LengthMetrics.vp(StyleConstants.DEFAULT_12),
        top: StyleConstants.DEFAULT_4,
        bottom: StyleConstants.DEFAULT_4
      })
      .padding({
        top: Math.ceil(vp2px(StyleConstants.DEFAULT_3)) + 'px',
        bottom: Math.ceil(vp2px(StyleConstants.DEFAULT_3)) + 'px'
      })
  }
}
