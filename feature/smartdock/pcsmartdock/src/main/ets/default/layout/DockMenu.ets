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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { MenuInfo, StyleConstants } from '@ohos/launchercommon';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { DockMenuViewModel } from '../viewmodel/DockMenuViewModel';
import { DockMenuCategory } from '../model/DockMenuCategory';
import { DockMenuItem } from './DockMenuItem';
import { DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';

const TAG = 'DockMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

@Component
export struct DockMenu {
  appParams?: Map<string, Object>;
  minTextWidth?: number;
  closeMenu: Function = () => {};
  private isBothTypeMenuExist: boolean = true;
  private menuOnAppear: Function = () => {};
  private menuOnDisAppear: Function = () => {};
  @Link viewModel: DockMenuViewModel;
  private ratio: number = 1;
  @Provide('dockMenuTextWidth') dockMenuTextWidth: number = StyleConstants.MENU_FONTSIZE;
  @Provide('dockMenuImageWidth') dockMenuImgWidth: number = 0;
  @State menuCategoryList: DockMenuCategory[] | undefined = undefined;

  private deleteTaskCallback = (taskInfo: DockMenuTaskInfo) => {
    animateTo({
      duration: 100
    }, async () => {
      await this.viewModel.deleteMenuTask(taskInfo);
      this.menuCategoryList = this.viewModel.getCategoryList();
    })
  };

  async aboutToAppear(): Promise<void> {
    log.showInfo('aboutToAppear start');
    this.viewModel.getMenuInfoList();
    this.menuCategoryList = this.viewModel.getCategoryList();
    this.isBothTypeMenuExist = this.viewModel.getFixedMenuList().length > 0 &&
      this.viewModel.getDynamicMenuList().length > 0;
    if (CheckEmptyUtils.isEmpty(this.minTextWidth)) {
      this.dockMenuTextWidth = StyleConstants.MENU_FONTSIZE;
    } else {
      this.dockMenuTextWidth = FixedDockResource.MENU_TEXT_WIDTH;
    }
    AppStorage.setOrCreate<boolean>('isLongPress', true);
    AppStorage.setOrCreate<boolean>('contextMenuState', true);
    this.menuOnAppear();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    AppStorage.setOrCreate<boolean>('contextMenuState', false);
    this.menuOnDisAppear();
  }

  @Builder
  fixedMenuItemBuilder() {
    Column({ space: StyleConstants.DEFAULT_2 }) {
      ForEach(this.viewModel.getFixedMenuList(), (item: MenuInfo, index?: number) => {
        DockMenuItem({
          screenId: this.viewModel.getScreenId(),
          menuInfo: item,
          closeMenu: this.closeMenu,
          appParams: this.appParams,
          ratio: this.ratio,
          menuOnDisAppear: this.menuOnDisAppear
        })
          .id(`${TAG}_HorizontalMenuItem_fixedMenu${index}`)
      }, (item: MenuInfo) => JSON.stringify(item))
    }
  }

  @Builder
  separatorBuilder() {
    Row() {
      Divider()
        .focusable(false)
        .vertical(false)
        .color($r('sys.color.ohos_id_color_list_separator'))
        .strokeWidth('1px')
        .focusable(false)
        .margin({
          left: StyleConstants.DEFAULT_12 * this.ratio,
          right: StyleConstants.DEFAULT_12 * this.ratio,
        })
    }
    .height(StyleConstants.DEFAULT_9 * this.ratio)
    .padding({
      top: StyleConstants.MENU_MARGIN * this.ratio,
      bottom: StyleConstants.MENU_MARGIN * this.ratio
    })
  }

  @Builder
  dynamicMenuItemBuilder() {
    Column({ space: StyleConstants.DEFAULT_2 }) {
      ForEach(this.viewModel.getDynamicMenuList(), (item: MenuInfo, index?: number) => {
        DockMenuItem({
          screenId: this.viewModel.getScreenId(),
          menuInfo: item,
          closeMenu: this.closeMenu,
          appParams: this.appParams,
          ratio: this.ratio,
          menuOnDisAppear: this.menuOnDisAppear
        })
          .id(`${TAG}_HorizontalMenuItem_dynamicMenu${index}`)
      }, (item: MenuInfo) => JSON.stringify(item))
    }
  }

  @Builder
  shortcutMenuBuilder() {
    Column({ space: StyleConstants.DEFAULT_2 }) {
      ForEach(this.viewModel.getShortcutMenuList(), (item: MenuInfo, index?: number) => {
        DockMenuItem({
          screenId: this.viewModel.getScreenId(),
          menuInfo: item,
          closeMenu: this.closeMenu,
          appParams: this.appParams,
          ratio: this.ratio,
          menuOnDisAppear: this.menuOnDisAppear
        })
          .id(`${TAG}_HorizontalMenuItem_shortcutMenu${index}`)
      }, (item: MenuInfo) => JSON.stringify(item))
    }
  }

  @Builder
  menuTitleBuilder(categoryName: string) {
    Column() {
      Text(categoryName)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontSize(FixedDockResource.DOCK_MENU_SUB_TITLE_SIZE * this.ratio)
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .margin({
          left: StyleConstants.DEFAULT_12,
          right: StyleConstants.DEFAULT_12
        })
    }
    .height(StyleConstants.DEFAULT_40 * this.ratio)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  menuTaskGroupBuilder(category: DockMenuCategory) {
    if (category.taskList.length > 0) {
      this.menuTitleBuilder(category.categoryName)
      Column({ space: StyleConstants.DEFAULT_2 }) {
        ForEach(category.taskList, (taskInfo: DockMenuTaskInfo) => {
          DockMenuItem({
            screenId: this.viewModel.getScreenId(),
            menuInfo: this.viewModel.getMenuInfo(taskInfo),
            menuTaskInfo: taskInfo,
            closeMenu: this.closeMenu,
            appParams: this.appParams,
            ratio: this.ratio,
            deleteTaskCallback: this.deleteTaskCallback,
            menuOnDisAppear: this.menuOnDisAppear
          })
        })
      }
    }
  }

  @Builder
  menuTaskListBuilder() {
    ForEach(this.menuCategoryList, (category: DockMenuCategory) => {
      this.menuTaskGroupBuilder(category)
    })
    this.separatorBuilder()
  }

  build() {
    Menu() {
      if (this.menuCategoryList && this.menuCategoryList.length > 0) {
        this.menuTaskListBuilder();
      }

      if (this.viewModel.getShortcutMenuList().length > 0) {
        this.shortcutMenuBuilder();
        this.separatorBuilder();
      }

      if (this.viewModel.getDynamicMenuList().length > 0) {
        this.dynamicMenuItemBuilder();
      }

      if (this.isBothTypeMenuExist) {
        this.separatorBuilder();
      }

      if (this.viewModel.getFixedMenuList().length > 0) {
        this.fixedMenuItemBuilder();
      }
    }
    .borderRadius(StyleConstants.DEFAULT_8 * this.ratio)
    .width(((this.dockMenuTextWidth + this.dockMenuImgWidth + StyleConstants.DEFAULT_32) >
    FixedDockResource.DOCK_MENU_MAX_WIDTH ? FixedDockResource.DOCK_MENU_MAX_WIDTH :
      (this.dockMenuTextWidth + this.dockMenuImgWidth + StyleConstants.DEFAULT_32)) * this.ratio)
    .padding({
      top: (StyleConstants.MENU_MARGIN + 0.5) * this.ratio,
      bottom: (StyleConstants.MENU_MARGIN + 0.5) * this.ratio,
      left: StyleConstants.MENU_MARGIN * this.ratio,
      right: StyleConstants.MENU_MARGIN * this.ratio,
    })
  }
}