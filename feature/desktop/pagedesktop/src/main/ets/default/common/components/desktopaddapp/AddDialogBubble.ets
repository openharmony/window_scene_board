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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import {
  AppIconCommonView,
} from '@ohos/launchercommon/Index';
import { AppItemInfo, CommonConstants, OpenFolderStyleConfig} from '@ohos/launchercommon';
import { FolderIconConfigUtil } from '@ohos/launchercommon/src/main/ets/folder/model/FolderIconConfigUtil';
import { DesktopAddBubbleNodeParams } from './DesktopAddBubbleNodeParams';
import DesktopAddDialogConstant from './DesktopAddDialogConstant';
import { DesktopAddItemInfo } from './SCBDesktopAddViewModel';
import { AddDialogBubbleViewModel } from './AddDialogBubbleViewModel';

const TAG = 'AddDialogBubble';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 桌面添加应用反选弹窗中Item组件
 */
@Reusable
@Component
export struct AddDialogBubble {
  private params: DesktopAddBubbleNodeParams = new DesktopAddBubbleNodeParams();
  private appItem: AppItemInfo = new AppItemInfo();
  private itemNameSize: number = ResUtils.getNumber($r('sys.float.ohos_id_text_size_body3'));
  @State iconSize: number = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().iconSize;
  @State isChecked: boolean = false;
  @State checkedAppLength: number = 0;

  aboutToAppear(): void {
    this.appItem = this.params.item.itemInfo as AppItemInfo;
    this.isChecked = this.params.item.isChecked;
    AddDialogBubbleViewModel.getInstance().initAppName(this.appItem);
    log.showInfo(TAG, `aboutToAppear ${this.params.item.itemInfo.keyName} isChecked ${this.isChecked}`);
  }

  aboutToReuse(params: Record<string, Object>): void {
    this.params = params.params as DesktopAddBubbleNodeParams;
    log.showInfo(TAG, `aboutToReuse ${this.params.item.itemInfo.keyName} isChecked ${this.isChecked}`);
  }

  build() {
    RelativeContainer() {
      AppIconCommonView({
        item: this.params.item.itemInfo as AppItemInfo,
        iconSize: this.iconSize,
        nameFontColor: CommonConstants.FOLDER_APP_NAME_COLOR,
        nameSize: this.itemNameSize,
        nameWidth: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_WIDTH,
        nameHeight: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_HEIGHT,
        nameMarginTop: DesktopAddDialogConstant.DESKTOP_ADD_ICON_NAME_MARGIN_TOP,
        appIconConfig: FolderIconConfigUtil.getAddDialogBubbleConfig({
          onIconClick: (event?: ClickEvent, fingers?: number): void => {
            log.showInfo(TAG, `onIconClick keyName ${this.params.item.itemInfo.keyName}`);
            this.params.onGridItemClick?.(this.params.item);
          }
        })
      })
      CheckBox({
        info: this.params.item,
        iconSize: this.iconSize,
        onCheckChange: (isOn: boolean, info: DesktopAddItemInfo) => {
          if (this.params.onCheckChange) {
            log.showInfo(TAG, `CheckBox onCheckChange isOn ${isOn} keyName ${info.itemInfo.keyName}`)
            this.checkedAppLength = this.params.onCheckChange(isOn, info);
            this.isChecked = isOn;
          }
        }
      })
    }
    .onClick((event?: ClickEvent) => {
      log.showInfo(TAG, `RelativeContainer onClick keyName ${this.params.item.itemInfo.keyName}`);
      this.params.onGridItemClick?.(this.params.item);
    })
  }
}

/**
 * 选择框
 */
@Component
struct CheckBox {
  @ObjectLink info: DesktopAddItemInfo;
  private iconSize: number = 0;
  private offsetX: number = 0;
  private onCheckChange: Function = (isOn: boolean, info: DesktopAddItemInfo): void => {
  };

  aboutToAppear(): void {
    this.offsetX = (this.iconSize - DesktopAddDialogConstant.CHECKBOX_SIZE) / 2 +
    DesktopAddDialogConstant.CHECKBOX_MARGIN;
  }

  build() {
    Checkbox()
      .width(DesktopAddDialogConstant.CHECKBOX_SIZE)
      .height(DesktopAddDialogConstant.CHECKBOX_SIZE)
      .padding(DesktopAddDialogConstant.CHECKBOX_PADDING)
      .accessibilityLevel('no')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .margin({ top: -DesktopAddDialogConstant.CHECKBOX_MARGIN })
      .offset({ x: this.offsetX })
      .onChange((isOn: boolean) => {
        this.onCheckChange?.(isOn, this.info);
      })
      .hitTestBehavior(HitTestMode.None)
      .select(this.info?.isChecked)
  }
}
