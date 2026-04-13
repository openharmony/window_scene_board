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

import systemDateTime from '@ohos.systemDateTime';
import { CardItemInfo, MenuInfoManager } from '@ohos/launchercommon';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackViewModel } from '../viewmodel/FormStackViewModel';
import type { FormStackItemInfo } from './FormStackItemInfo';
import { FormStackUtil } from './FormStackUtil';
import { FormStackManager } from './FormStackManager';
import { FormStackConstants } from './FormStackConstants';

const TAG: string = 'FormStackExpandModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandModel {
  public mFormStackId: string = '';
  private mFormStackExpandTime: number = 0;
  private mViewModel: FormStackViewModel = new FormStackViewModel();
  private mCardItemsMap: Map<string, CardItemInfo> = new Map<string, CardItemInfo>();

  public initData(formStackItemInfo: FormStackItemInfo): boolean {
    let itemList: CardItemInfo[] = formStackItemInfo?.layoutInfo?.[0];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showInfo('formStackItemInfo layoutInfo is invalid!');
      return false;
    }

    log.showInfo(`start to init item info, itemList len: ${itemList.length}.`);
    itemList.forEach((item) => {
      if (!FormStackUtil.isValidCard(item)) {
        log.showError('init form stack edit info failed, cardInfo is invalid!');
        return;
      }

      item.name = item.cardName;
      item.id = item.cardId;
      item.dimension = item.cardDimension;
      item.column = formStackItemInfo.column;
      item.row = formStackItemInfo.row;
      item.page = formStackItemInfo.page;

      const id: string = `${FormStackConstants.FORM_STACK_EXPAND_ID_PREFIX}_${item.cardId}`;
      this.setCardInfo(id, item);
    });

    return true;
  }

  public resetData(): void {
    this.mFormStackId = '';
    this.mFormStackExpandTime = 0;
    this.mCardItemsMap.clear();
  }

  public swapForm(id1: string, id2: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id1) || CheckEmptyUtils.checkStrIsEmpty(id2)) {
      log.showError(`swap form failed, [id1: ${id1} or id2: ${id2}] is invalid!`);
      return;
    }

    let formStackManager: FormStackManager = FormStackManager.getInstance();
    let cardInfo1: CardItemInfo = this.getCardInfo(id1) as CardItemInfo;
    let cardInfo2: CardItemInfo = this.getCardInfo(id2) as CardItemInfo;
    if (!FormStackUtil.isValidCard(cardInfo1) || !FormStackUtil.isValidCard(cardInfo2)) {
      log.showError(`swap form failed, [id1: ${id1} or id2: ${id2}], cardInfo1 or cardInfo2 is invalid!`);
      return;
    }

    log.showInfo(`start to swap form, cardId: [${cardInfo1.cardId}, ${cardInfo2.cardId}].`);
    this.mViewModel.swapFormStackCard(formStackManager.getFormStackId(), cardInfo1.cardId, cardInfo2.cardId, isOuter);
  }

  public swapFormToTopOfFormStack(id: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError(`swap form to top of form stack failed, id: ${id} is invalid!`);
      return;
    }

    let cardInfo: CardItemInfo = this.getCardInfo(id) as CardItemInfo;
    if (!FormStackUtil.isValidCard(cardInfo)) {
      log.showError(`swap form to top of form stack failed, id: ${id}, cardInfo is invalid!`);
      return;
    }

    log.showInfo(`start to swap form to top of form stack, cardId: ${cardInfo.cardId}.`);
    this.mViewModel.swapCardToTopOfFormStack(this.mFormStackId, cardInfo.cardId, isOuter);
  }

  /**
   * 删除堆叠中的卡片
   * @param id 堆叠卡片标识ID
   * @param isDeleteLocal true: 直接删除 false: 从堆叠删除，刷新到桌面
   * @param isOuter 是否外屏
   * @param removeDelay 框架删卡时延: 走退场动效时、需要框架延时删卡，否则退场动效将过程中卡片会透明
   */
  public deleteForm(id: string, isDeleteLocal: boolean, isOuter?: boolean, removeDelay = 0): void {
    log.showInfo(`delete card of formstack. id: ${id}, isDeleteLocal: ${isDeleteLocal}`);
    if (CheckEmptyUtils.checkStrIsEmpty(id)) {
      log.showError('delete form failed, id is invalid!');
      return;
    }

    let cardInfo: CardItemInfo = this.getCardInfo(id) as CardItemInfo;
    if (!FormStackUtil.isValidCard(cardInfo)) {
      log.showError(`delete form failed, id: ${id}, cardInfo is invalid!`);
      return;
    }
    MenuInfoManager.getInstance().unregisterContextMenuListener(cardInfo.cardId);
    log.showInfo(`start to delete form, cardId: ${cardInfo.cardId}.`);
    if (isDeleteLocal) {
      this.mViewModel.deleteCardsFromFormStack(this.mFormStackId, [cardInfo.cardId], undefined, isOuter, removeDelay);
    } else {
      this.mViewModel.deleteCardCache(this.mFormStackId, cardInfo.cardId, isOuter);
    }
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      let deleteFormText: string = ResUtils.getInnerStringNumS(
        $r('app.string.delete_stack_form'), `${cardInfo.appName ?? ''}`);
      AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(deleteFormText, 'textAnnouncedForDeleteStack');
    }
    this.deleteCardInfo(id);
  }

  public onDisplayChanged(display: boolean): void {
    let displayTime: number = 0;
    let formStackManager: FormStackManager = FormStackManager.getInstance();
    if (display) {
      this.mFormStackExpandTime = systemDateTime.getTime();
    } else {
      displayTime = systemDateTime.getTime() - this.mFormStackExpandTime;
    }

    this.mViewModel.onDisplayChanged(formStackManager.getFormStackId(), display, displayTime);
  }

  public notifyCloseFormStackExpandView(formStackId: string): void {
    this.mViewModel.notifyCloseFormStackExpandView(formStackId);
  }

  public deleteAllCardInfo(): void {
    this.mCardItemsMap.clear();
  }

  public getAllCards(): CardItemInfo[] {
    let cardItemArr: CardItemInfo[] = [];
    for (let info of this.mCardItemsMap.values()) {
      cardItemArr.push(info);
    }
    return cardItemArr;
  }

  public getAllCardsNum(): number {
    return this.mCardItemsMap.size;
  }

  public getCardInfo(id: string): CardItemInfo | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(id) || !this.mCardItemsMap.has(id)) {
      log.showError(`get cardInfo failed, id: ${id} is invalid!`);
      return undefined;
    }

    return this.mCardItemsMap.get(id);
  }

  public setCardInfo(id: string, cardInfo: CardItemInfo): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id) || CheckEmptyUtils.isEmpty(cardInfo)) {
      log.showError(`set cardInfo failed, id: ${id} or cardId: ${cardInfo?.cardId}} is invalid!`);
      return;
    }

    this.mCardItemsMap.set(id, cardInfo);
  }

  public deleteCardInfo(id: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(id) || !this.mCardItemsMap.has(id)) {
      log.showError(`delete cardInfo failed, id: ${id} is invalid!`);
      return;
    }

    this.mCardItemsMap.delete(id);
  }

  public notifyDesktopUpdate(): void {
    this.mViewModel.updateDesktop();
  }

  public emitFormStackClosedMsg(cardId: string): void {
    this.mViewModel.notifyLastFormShow(cardId);
  }
}