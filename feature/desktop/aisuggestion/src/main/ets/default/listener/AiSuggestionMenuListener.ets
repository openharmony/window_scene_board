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

import { LogDomain, Logger} from '@ohos/basicutils';
import { FormManagerDialog } from '@ohos/form';
import {
  CardItemInfo,
  GridLayoutItemInfo,
  MenuInfo,
  CommonConstants,
  ContextMenuListener,
  EventConstants
} from '@ohos/launchercommon';
import { AiSuggestionComponentData } from '../bean/AiSuggestionComponentData';
import { AiSuggestionMenuBuilder } from '../menu/AiSuggestionMenuBuilder';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import { localEventManager } from '@ohos/frameworkwrapper';

const TAG = 'AiSuggestionMenuListener';
const log: Logger = Logger.getLogHelper(LogDomain.AISUGGESTION);

/**
 * 菜单监听器
 *
 * @since 2025-06-18
 */
export class AiSuggestionMenuListener implements ContextMenuListener {
  private formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private viewData: AiSuggestionComponentData = new AiSuggestionComponentData();
  public isOuterDesktop: boolean = false;
  public isFormStackChildItem: boolean = false;
  private clearForm = () => {
  };

  public constructor(formItem: GridLayoutItemInfo, viewData: AiSuggestionComponentData, isOuterDesktop: boolean,
    isFormStackChildItem: boolean) {
    this.formItem = formItem;
    this.viewData = viewData;
    this.isOuterDesktop = isOuterDesktop;
    this.isFormStackChildItem = isFormStackChildItem;
  }

  /**
   * 获取菜单列表
   *
   * @param containerType 所属容器，堆叠/桌面
   * @param responseType 响应类型
   * @returns 菜单列表
   */
  public onMenuBuild(containerType: number, responseType?: ResponseType): MenuInfo[] {
    return this.getMenuInfoList(containerType);
  }

  /**
   * 菜单显示时
   *
   * @param responseType 响应类型
   */
  public onMenuAppear(responseType?: ResponseType): void {
    AiSuggestionEventReporter.getInstance()
      .reportSuggestionFormIconLongPress(this.formItem, this.viewData.selectedItem);
    AiSuggestionEventReporter.getInstance().reportSuggestionFormMenu(this.formItem, this.viewData.isItemSelected ?
    this.viewData.selectedItem : undefined);
  }

  /**
   * 菜单消失时
   *
   * @param responseType 响应类型
   */
  public onMenuDisappear(responseType?: ResponseType): void {
    if (responseType === ResponseType.LongPress) {
      this.viewData.isItemSelected = false;
    }
  }

  private getMenuInfoList(containerType: number): MenuInfo[] {
    let formDialog = this.getDialogController(this.formItem);
    if (this.isOuterDesktop) {
      return new AiSuggestionMenuBuilder().buildExternalMenu(containerType, this.formItem);
    }
    if (this.viewData.isItemSelected) {
      return new AiSuggestionMenuBuilder().buildChildServiceMenu(this.formItem, containerType,
        this.viewData.selectedItem,
        formDialog);
    }

    // 堆叠单卡长按默认选中第0个服务
    if (this.isFormStackChildItem && AbilityFormUtil.isFullFill(this.viewData.recItems)) {
      return new AiSuggestionMenuBuilder().buildChildServiceMenu(this.formItem, containerType,
        this.viewData.recItems[0], formDialog);
    }
    return new AiSuggestionMenuBuilder().buildParentServiceMenu(this.formItem, containerType,
      this.viewData.portfolioInfo, formDialog);
  }

  private cancelFormDialog(): void {
    log.showInfo(TAG, 'cancel dialog');
    this.clearForm();
  };

  private getDialogController(formItem: GridLayoutItemInfo): CustomDialogController {
    let controller = new CustomDialogController({
      builder: FormManagerDialog({
        cancel: (callback?: () => void) => {
          if (callback !== undefined) {
            this.clearForm = callback;
          } else {
            this.clearForm = () => {
            };
            log.showError(TAG, 'FormManagerDialog cancel with callback null'); // 维测日志
          }
        },
        confirm: (formCardItem: CardItemInfo) => {
          // add form to desktop
          log.showWarn(TAG, `createCardToDeskTop name=${formCardItem.name}, cardName=${formCardItem.cardName}`);
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD, formCardItem);
          controller.close();
        },
        bundleName: formItem.bundleName,
        appName: this.viewData.portfolioInfo?.name,
        appLabelId: formItem.appLabelId,
        isPcEditCard: AppStorage.get<string>('device') !== CommonConstants.DEFAULT_DEVICE_TYPE,
      }),
      cancel: this.cancelFormDialog,
      autoCancel: true,
      customStyle: true,
      showInSubWindow: true
    });
    return controller;
  }
}