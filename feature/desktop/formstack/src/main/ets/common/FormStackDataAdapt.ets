/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import { desktopUtil } from '@ohos/componenthelper';
import type { DragItemPosition } from '@ohos/componentdrag';
import { CommonConstants } from '@ohos/launchercommon';
import type { CardItemInfo } from '@ohos/launchercommon';

const TAG: string = 'FormStackDataAdapt';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export enum FormStackMsg {
  SET_FORM_STACK_ITEM_INFO,
  OPEN_FORM_STACK_CRITICAL_INFO, // 堆叠卡片展开前的临界状态
  SET_FORM_STACK_OUTER_MENU,
};

export class FormStackDataAdapt {
  private static mInstance: FormStackDataAdapt = new FormStackDataAdapt();
  private formStackMsgMap: Map<FormStackMsg, Function> = new Map();

  public static getInstance(): FormStackDataAdapt {
    return FormStackDataAdapt.mInstance;
  }

  public registerMsg<T>(msg: FormStackMsg, handler: (t: T) => void): boolean {
    if (CheckEmptyUtils.isEmpty(handler)) {
      log.showInfo(`register msg: ${msg} failed, handler is invalid!`);
      return false;
    }

    log.showInfo(`register msg: ${msg} succeed.`);
    this.formStackMsgMap.set(msg, handler);
    return true;
  }

  public unregisterMsg(msg: FormStackMsg): void {
    if (this.formStackMsgMap.has(msg)) {
      this.formStackMsgMap.delete(msg);
    }
  }

  public handleMsg<T>(msg: FormStackMsg, data: T): void {
    if (!this.formStackMsgMap.has(msg) || CheckEmptyUtils.isEmpty(this.formStackMsgMap.get(msg))) {
      log.showError(`msg: ${msg} is not registered!`);
      return;
    }

    log.showInfo(`start to handle msg: ${msg}.`);
    this.formStackMsgMap.get(msg)?.(data);
  }

  public setDragItemInfo(formStackId: string, cardInfo: CardItemInfo): void {
    if (!CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      // 需要严格保证isDrag和dragItemInfo的刷新顺序
      AppStorage.setOrCreate('isDrag', true);
      AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_FORM_STACK);
      AppStorage.setOrCreate('formStackId', formStackId);
      AppStorage.setOrCreate('selectItem', '');
      AppStorage.setOrCreate('dragItemInfo', this.toDragItemInfo(cardInfo));
      AppStorage.setOrCreate('dragCardOfFormstackClosed', false);
      this.clearDragStartPosition();
      log.showInfo('set drag item info success.');
      return;
    }

    AppStorage.setOrCreate('isDrag', false);
    AppStorage.setOrCreate('dragItemInfo', cardInfo);
    log.showInfo('reset drag item info success.');
  }

  private toDragItemInfo(cardInfo: CardItemInfo): CardItemInfo {
    // 卡片堆叠中拖出的卡片位置信息无效，需要置空使落位时不会被之前的位置影响
    let dragItemInfo: CardItemInfo = JSON.parse(JSON.stringify(cardInfo));
    dragItemInfo.column = undefined;
    dragItemInfo.row = undefined;
    return dragItemInfo;
  }

  private clearDragStartPosition(): void {
    // 拖拽事件开始时清除上一次拖拽组件位置
    const defaultPosition: DragItemPosition = {
      page: desktopUtil.getPageIndexValue(),
      row: 0,
      column: 0,
      x: 0,
      y: 0
    };
    AppStorage.setOrCreate('startPosition', defaultPosition);
  }
}