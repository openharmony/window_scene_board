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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import {
  AppBubbleParams,
  AppIconCommonView,
  AppIconContainerModifier,
  DeskTopItemStyle,
} from '@ohos/launchercommon/Index';
import {
  AppItemInfo,
  GridLayoutItemInfo,
  CommonConstants,
  FolderStyleManager,
  OpenFolderStyleConfig,
} from '@ohos/launchercommon';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { FolderIconConfigUtil } from '@ohos/launchercommon/src/main/ets/folder/model/FolderIconConfigUtil';
import {
  BigFolderAppDefaultModifier
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/BigFolderAppDefaultModifier';
import DesktopAddDialogConstant from './DesktopAddDialogConstant';
import { DesktopAddDialogShowInfo, SCBDesktopAddViewModel } from './SCBDesktopAddViewModel';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import { DesktopAddBubbleViewModel } from './DesktopAddBubbleViewModel';
import SCBDesktopAddDialog from './SCBDesktopAddDialog';

const TAG = 'DesktopAddBubble';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

@Component
export default struct DesktopAddBubble {
  @Prop appItemWidth: number = 0;
  @State isDesktopAddDialogShowInfo: DesktopAddDialogShowInfo = SCBDesktopAddViewModel.getInstance()
    .desktopAddDialogShowInfo;
  private desktopAddBubbleVM = DesktopAddBubbleViewModel.getInstance();
  private itemNameSize: number = ResUtils.getNumber($r('sys.float.ohos_id_text_size_body3'));
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  @State appData: AppIconData = new AppIconData();
  @StorageProp('isDrag') isDrag: boolean = false;
  @ObjectLink @Watch('onDesktopStyleChange') desktopStyle: DeskTopItemStyle;

  private appIconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
    () => this.desktopAddBubbleVM.updateModifier(this.desktopStyle, this.appIconContainerModifier));

  private onIconClick = (event?: ClickEvent): void => {
    if (launcherStatusUtil.getDesktopAddModeStatus()) {
      log.showInfo(TAG, 'click Add Inactive, because dialog is opened.');
      return;
    }
    log.showInfo(TAG, 'Click add to open dialog.');
    this.updateIsDesktopDialogShow(true);
  }

  private updateIsDesktopDialogShow = (newIsShow: boolean) => {
    this.isDesktopAddDialogShowInfo.isDesktopDialogShow = newIsShow;
    launcherStatusUtil.setDesktopAddModeStatus(newIsShow);
  }

  private onDesktopStyleChange(): void {
    this.desktopAddBubbleVM.updateModifier(this.desktopStyle, this.appIconContainerModifier);
  }

  aboutToAppear(): void {
    this.item.typeId = CommonConstants.TYPE_ADD;
    this.item.bundleName = CommonConstants.SCENEBOARD_BUNDLE;
    this.item.appLabelId = $r('app.string.desktop_add').id;
    this.item.appName = ResourceManager.getInstance().getStringByName('folder_add');
    openFolderAppBubbleLayout.setIconData(this.item.keyName ?? this.item.bundleName, this.appData);
  }

  @Builder
  dialogContentBuilder() {
    Column() {
      SCBDesktopAddDialog({
        isShow: this.isDesktopAddDialogShowInfo.isDesktopDialogShow,
        onIsShowChange: this.updateIsDesktopDialogShow
      })
    }
  }

  @Builder
  AddButton() {
    Image(DesktopAddDialogConstant.OPEN_FOLDER_ADD_ICON_SRC)
      .width(DesktopAddDialogConstant.OPEN_FOLDER_ADD_ICON_IMAGE_SIZE)
      .height(DesktopAddDialogConstant.OPEN_FOLDER_ADD_ICON_IMAGE_SIZE)
      .draggable(false)
  }

  build() {
    AppIconCommonView({
      item: this.item as AppItemInfo,
      iconSize: this.appItemWidth,
      nameSize: this.itemNameSize,
      nameFontColor: FolderStyleManager.getInstance().getNameFontColor(),
      nameWidth: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_WIDTH,
      nameHeight: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_HEIGHT,
      nameMarginTop: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_MARGIN_TOP,
      iconData: this.appData,
      iconModifier: this.desktopAddBubbleVM.getAddIconModifier(this.appItemWidth),
      iconContainerModifier: this.appIconContainerModifier,
      extendIconBuilder: () => this.AddButton(),
      appIconConfig: FolderIconConfigUtil.getAddDialogBubbleConfig({
        onIconClick:(event?: ClickEvent, fingers?: number): void => {
          this.onIconClick();
        }
      })
    }).visibility(!this.isDrag ? Visibility.Visible : Visibility.Hidden)
      .bindSheet($$this.isDesktopAddDialogShowInfo.isDesktopDialogShow,
        this.dialogContentBuilder(), {
        height: SheetSize.MEDIUM,
        uiContext: this.getUIContext(),
        mode: SheetMode.OVERLAY,
        scrollSizeMode: ScrollSizeMode.CONTINUOUS,
        backgroundColor: Color.Gray,
        blurStyle: BlurStyle.Thick,
        showClose: true,
        title: { title: $r('app.string.desktop_add')},
      });
  }

}