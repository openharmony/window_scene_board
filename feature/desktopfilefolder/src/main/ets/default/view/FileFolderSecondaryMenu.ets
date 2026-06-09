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
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { MenuInfo, StyleConstants, EventConstants } from '@ohos/launchercommon';
import { FileFolderMenuViewModel } from '../viewmodel/FileFolderMenuViewModel';
import {
  localEventManager,
} from '@ohos/frameworkwrapper';
import { LengthMetrics } from '@kit.ArkUI';
import FileFolderManagerFactory from '../manager/FileFolderManagerFactory';
import FileFolderManager from '../manager/FileFolderManager';
import { MenuConstants } from '../common/FileFolderConstants';
import { MenuSeparator } from './FileFolderMenu';

const TAG = 'FileFolderSecondaryMenu';
const log = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件文件夹二级菜单
 */
@Component
export default struct FileFolderSecondaryMenu {
  private menuKeyString: string = '';
  @State menuInfos: MenuInfo[] = [];
  private isClicked: boolean = false;
  private menuVM: FileFolderMenuViewModel = FileFolderMenuViewModel.getInstance();
  private fileFolderManager: FileFolderManager = FileFolderManagerFactory.getFileFolderManager();
  private uri: string = '';
  private firstMenuItem: MenuInfo = new MenuInfo();

  aboutToAppear(): void {
    if (!CheckEmptyUtils.isEmptyArr(this.firstMenuItem.subMenuList)) {
      this.menuInfos = this.firstMenuItem.subMenuList;
    } else {
      this.menuInfos = this.fileFolderManager.getSecondaryMenuInfo(this.menuKeyString, this.uri);
    }
    log.showInfo(TAG, `aboutToAppear ${this.menuKeyString}`);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear ${this.menuKeyString}`);
  }

  build() {
    Menu() {
      ForEach(this.menuInfos, (item: MenuInfo) => {
        if (this.menuVM.isSeparatorItem(item)) {
          this.separatorBuilder()
        } else {
          this.menuItemBuilder(item)
        }
      }, (item: MenuInfo) => JSON.stringify(item))
    }
    .width(this.menuVM.getMaxMenuWidth(this.menuInfos) + MenuConstants.DEFAULT_MENU_ITEM_SIDE_PADDING * 2)
    .padding({
      bottom: StyleConstants.DEFAULT_2,
      top: StyleConstants.DEFAULT_2,
      start: LengthMetrics.vp(StyleConstants.DEFAULT_4),
      end: LengthMetrics.vp(StyleConstants.DEFAULT_4)
    })
  }

  @Builder
  separatorBuilder() {
    MenuSeparator()
  }

  @Builder
  menuItemBuilder(item: MenuInfo) {
    MenuItem({
      content: item.menuText,
      startIcon: item.menuImgSrc as ResourceStr
    })
    .id(`${TAG}_${item.menuKeyString}`)
    .margin({
      top: StyleConstants.DEFAULT_2,
      bottom: StyleConstants.DEFAULT_2
    })
    .height(MenuConstants.MENU_ITEM_HEIGHT)
    .onClick((event?: ClickEvent) => {
      if (this.isClicked) {
        return;
      }
      this.isClicked = true;
      if (item?.onMenuClick) {
        item?.onMenuClick();
      }
      ContextMenu.close();
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
      setTimeout(() => {
        this.isClicked = false;
      }, MenuConstants.CLICK_DELAY);
    })
  }

}