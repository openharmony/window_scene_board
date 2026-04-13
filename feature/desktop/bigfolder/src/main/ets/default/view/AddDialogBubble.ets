/*
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
 *
 */
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { GlobalContext, AccessibilityManager, ResourceManager, IconResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  AppBubbleCommonParams,
  AppIconCommonView,
} from '@ohos/launchercommon/Index';
import { AppItemInfo, CommonConstants, GridLayoutUtil, OpenFolderStyleConfig} from '@ohos/launchercommon';
import { AddDialogBubbleNodeParams } from '../common/AddDialogBubbleNodeParam';
import { FolderAddItemInfo } from '../viewmodel/OpenFolderAddViewModel';
import FolderAddDialogConstant from '../common/constants/FolderAddDialogConstant';
import { FolderIconConfigUtil } from '@ohos/launchercommon/src/main/ets/folder/model/FolderIconConfigUtil';
import { OpenFolderAppBubbleNodeManager } from './node/OpenFolderAppBubbleNodeManager';

const TAG = 'AddDialogBubble';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹反选弹窗中Item组件
 */
@Reusable
@Component
export struct AddDialogBubble {
  private params: AddDialogBubbleNodeParams = new AddDialogBubbleNodeParams();
  private appItem: AppItemInfo = new AppItemInfo();
  private folderName: string = '';
  private bubbleParams: AppBubbleCommonParams = OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams();
  private itemNameSize: number = ResUtils.getNumber($r('sys.float.ohos_id_text_size_body3'));
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State iconSize: number = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().iconSize;
  @State isChecked: boolean = false;
  @State checkedAppLength: number = 0;

  private getAccessibilityDescription(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    return ResourceManager.getInstance().getStringByName(
      this.isChecked ? 'double_tap_to_uncheck' : 'double_tap_to_check');
  }

  private getCheckStatusReaderText(): string {
    return ResourceManager.getInstance().getStringByName(
      this.isChecked ? 'app_checked' : 'app_not_checked');
  }

  private initAppName(): void {
    if (GridLayoutUtil.isShortcutToDesktopInApp(this.appItem)) {
      return;
    }
    if (this.appItem.typeId === CommonConstants.TYPE_APP && GridLayoutUtil.isAppInstalled(this.appItem)) {
      this.appItem.appName = IconResourceManager.getInstance().getCachedIconNameSync(this.appItem.bundleName,
        this.appItem.moduleName, this.appItem.abilityName) ?? this.appItem.appName;
    } else if (this.appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.appItem.appName = ResourceManager.getInstance().getCachedAppName(this.appItem.appLabelId,
        this.appItem.bundleName, this.appItem.moduleName);
    }
  }

  aboutToAppear(): void {
    this.appItem = this.params.item.itemInfo as AppItemInfo;
    this.isChecked = this.params.item.isChecked;
    log.showInfo(`aboutToAppear ${this.params.item.itemInfo.keyName} isChecked ${this.isChecked}`);
    this.initAppName();
  }

  aboutToReuse(params: Record<string, Object>): void {
    this.params = params.params as AddDialogBubbleNodeParams;
    this.isChecked = this.params.item.isChecked;
    log.showInfo(`aboutToReuse ${this.params.item.itemInfo.keyName} isChecked ${this.isChecked}`);
  }

  build() {
    RelativeContainer() {
      if (this.isAccessibilityMode) {
        Text(this.getCheckStatusReaderText())
          .opacity(0)
          .fontSize(0)
      }
      AppIconCommonView({
        item: this.params.item.itemInfo as AppItemInfo,
        iconSize: this.iconSize,
        nameFontColor: CommonConstants.FOLDER_APP_NAME_COLOR,
        nameSize: this.itemNameSize,
        nameWidth: this.bubbleParams.nameWidth,
        nameHeight: this.bubbleParams.nameHeight,
        nameMarginTop: this.bubbleParams.mIconNameMargin,
        appIconConfig: FolderIconConfigUtil.getAddDialogBubbleConfig({
          onIconClick: (event?: ClickEvent, fingers?: number): void => {
            log.showInfo(`onIconClick keyName ${this.params.item.itemInfo.keyName}`);
            this.params.onGridItemClick?.(this.params.item);
          }
        })
      })

      CheckBox({
        info: this.params.item,
        iconSize: this.iconSize,
        onCheckChange: (isOn: boolean, info: FolderAddItemInfo) => {
          if (this.params.onCheckChange) {
            log.showInfo(`CheckBox onCheckChange isOn ${isOn} keyName ${info.itemInfo.keyName}`)
            this.checkedAppLength = this.params.onCheckChange(isOn, info);
            this.isChecked = isOn;
          }
        }
      })
    }
    .onClick((event?: ClickEvent) => {
      log.showInfo(`RelativeContainer onClick keyName ${this.params.item.itemInfo.keyName}`);
      this.params.onGridItemClick?.(this.params.item);
    })
    .accessibilityDescription(this.getAccessibilityDescription())
  }
}

/**
 * 选择框
 */
@Component
struct CheckBox {
  @ObjectLink info: FolderAddItemInfo;
  private iconSize: number = 0;
  private offsetX: number = 0;
  private onCheckChange: Function = (isOn: boolean, info: FolderAddItemInfo): void => {
  };

  aboutToAppear(): void {
    this.offsetX = (this.iconSize - FolderAddDialogConstant.CHECKBOX_SIZE) / 2 +
      FolderAddDialogConstant.CHECKBOX_MARGIN;
  }

  build() {
    Checkbox()
      .width(FolderAddDialogConstant.CHECKBOX_SIZE)
      .height(FolderAddDialogConstant.CHECKBOX_SIZE)
      .padding(FolderAddDialogConstant.CHECKBOX_PADDING)
      .accessibilityLevel('no')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .margin({ top: -FolderAddDialogConstant.CHECKBOX_MARGIN })
      .offset({ x: this.offsetX })
      .onChange((isOn: boolean) => {
        this.onCheckChange?.(isOn, this.info);
      })
      .hitTestBehavior(HitTestMode.None)
      .select(this.info?.isChecked)
  }
}
