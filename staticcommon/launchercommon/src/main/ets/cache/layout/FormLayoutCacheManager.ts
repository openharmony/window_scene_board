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

import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper, SingleContext, Trace
} from '@ohos/basicutils';
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import { CommonConstants, RdbHandleResult } from '../../constants/CommonConstants';

import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { ILayoutCacheManager } from './ILayoutCacheManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { ConvertUtil } from '../../utils/ConvertUtil';
import { CardItemInfo } from '../../bean/CardItemInfo';
import { BaseLayoutCacheManager } from './BaseLayoutCacheManager';
import { LauncherLayoutCacheUtil } from './LauncherLayoutCacheUtil';
import { BusinessType } from '../../constants/CommonConstants';
import { EventConstants } from '../../constants/EventConstants';
import { Extend1Data, FormModel, RdbStoreManager } from '../../TsIndex';

const TAG = 'FormLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FORMSTACK_CARDS_MIN_LEN = 2;

export class FormLayoutCacheManager extends BaseLayoutCacheManager implements ILayoutCacheManager {
  private static instance: FormLayoutCacheManager;

  static getInstance(): FormLayoutCacheManager {
    if (FormLayoutCacheManager.instance == null) {
      FormLayoutCacheManager.instance = new FormLayoutCacheManager();
    }
    return FormLayoutCacheManager.instance;
  }

  private constructor() {
    super();
  }

  selectGridLayoutItemByCardId(cardId: string, isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_CARD && item.cardId === cardId);
  }

  selectGridLayoutItemByFormstackId(formStackId: string, isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FORM_STACK && item.formStackId === formStackId);
  }

  selectGridLayoutItemsByBundleName(bundleName: string, isOuter?: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => item.bundleName === bundleName && item.typeId === CommonConstants.TYPE_CARD);
  }

  selectGridLayoutItemByPosition(page: number, row: number, col: number, isOuterDesktop?: boolean):
    GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuterDesktop);
    return gridLayoutItemList.find(item => (item.typeId === CommonConstants.TYPE_CARD || item.typeId === CommonConstants.TYPE_FORM_STACK) &&
      item.page === page && item.row === row && item.column === col);
  }

  selectGridLayoutItemByIndex(index: number): GridLayoutItemInfo | undefined{
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (index < 0 || index >= gridLayoutItemList.length || CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      return undefined;
    }
    let cardItem = gridLayoutItemList[index];
    if (cardItem.typeId !== CommonConstants.TYPE_CARD && cardItem.typeId !== CommonConstants.TYPE_FORM_STACK) {
      return undefined;
    }
    return cardItem;
  }

  /**
   * 查询所有的卡片列表
   *
   * @returns 桌面卡片和堆叠卡片的列表
   */
  selectAllFormsList(isOuter?: boolean): GridLayoutItemInfo[] {
    let allFormsAndFormStackList: GridLayoutItemInfo[] = this.selectAllFormsAndFormStack(isOuter);
    let allFormsInfoList: GridLayoutItemInfo[] = [];

    allFormsAndFormStackList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        allFormsInfoList.push(item);
        return;
      }
      if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        if (CheckEmptyUtils.isEmptyArr(item.layoutInfo)) {
          log.showWarn('current formStack is empty');
          return;
        }
        let stackFormInfo: GridLayoutItemInfo[] | undefined = item.layoutInfo?.[0];
        log.showInfo(`form length in formStack: ${stackFormInfo?.length}`);
        if (!stackFormInfo) {
          return;
        }
        stackFormInfo.forEach((value) => {
          value.cardDimension = CardItemInfo.getCardDimension(value.area ?? []);
          allFormsInfoList.push(value);
        });
      }
    });
    return allFormsInfoList;
  }

  /**
   * 获取所有的卡片数量
   *
   * @returns 桌面卡片和堆叠卡片数量
   */
  getAllFormsLen(): number {
    Trace.start('getAllFormsLen');
    let allFormsAndFormStackList: GridLayoutItemInfo[] = this.selectAllFormsAndFormStack();
    let allFormsInfoLen: number = 0;

    allFormsAndFormStackList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        allFormsInfoLen++;
      }
      if (item.typeId === CommonConstants.TYPE_FORM_STACK && item.layoutInfo &&
        !CheckEmptyUtils.isEmptyArr(item.layoutInfo)) {
        log.showInfo(`form length in formStack: ${item.layoutInfo[0].length}`);
        allFormsInfoLen += item.layoutInfo[0].length;
      }
    });
    Trace.end('getAllFormsLen');
    return allFormsInfoLen;
  }

  /**
   * 根据卡片位置删除卡片
   */
  deleteGridLayoutItemByPosition(page: number, row: number, col: number, label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.page !== page ||
      item.row !== row || item.column !== col);
    log.showInfo(`deleteItemByPosition, position: %{public}d, %{public}d, %{public}d, label: %{public}s,
      isDb: %{public}s oldResult: %{public}d newResult: %{public}d`, page, row, col, label, isOperateDb,
      gridLayoutItemList.length, newGridLayoutItemList.length);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFormInfoByPositionCallback(page, col, row, isOuter);
      } catch (error) {
        log.showError('deleteGridLayoutItemByPosition with error %{public}s', error.message);
      }
    }
  }

  /**
   * 根据堆叠id所有堆叠元素
   *
   * @param stackId 堆叠id
   * @returns  堆叠元素
   */
  selectFormStackItemByFormStackId(stackId: string, isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let formStackInfo: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.formStackId === stackId);
    if (!this.checkAndDealDirtyStack(formStackInfo, stackId)) {
      return undefined;
    }
    return formStackInfo;
  }

  /**
   * 根据id判断卡片是否处于外屏
   *
   * @returns 是否处于外屏
   */
  checkIfFormInExternalScreen(cardId: string): boolean {
    return false;
  }

  /**
   * 根据id判断卡片是否属于外屏堆叠
   *
   * @returns 是否属于外屏堆叠
   */
  checkIfFormInExternalStack(cardId: string): boolean {
    return false;
  }
  /**
   * 查询所有的卡片和堆叠
   *
   * @returns 卡片和堆叠的列表
   */
  selectAllFormsAndFormStack(isOuter?: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_CARD ||
      item.typeId === CommonConstants.TYPE_FORM_STACK);
  }

  /**
   * 查询bundleName的所有的卡片和堆叠
   *
   * @returns 卡片和堆叠的列表
   */
  selectFormsAndFormStackByBundleName(bundleName: string, isOuter: boolean = false): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError('selectFormsAndFormStackByBundleName bundleName is invalid!');
      return [];
    }

    return this.selectAllFormsAndFormStack(isOuter)?.filter(item => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        return item.bundleName === bundleName;
      } else if (item.typeId === CommonConstants.TYPE_FORM_STACK && item.layoutInfo && item.layoutInfo[0]?.length) {
        return item.layoutInfo[0].some(item => item.bundleName === bundleName);
      } else {
        return false;
      }
    }) ?? [];
  }

  /**
   * 根据bundleName移除卡片
   */
  deleteGridLayoutItemByBundleNameAndType(bundleName: string, typeId: number, label: string,
    isOperateDb: boolean = true, isOuter?: boolean): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let filter = (item: GridLayoutItemInfo): boolean => item.bundleName !== bundleName || item.typeId !== typeId;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    log.showInfo('deleteItemByBundleAndType, bundle: %{public}s, isDb: %{public}s, label: %{public}s,' +
      ' oldResult %{public}d, newResult %{public}d, isOuter %{public}s',
      bundleName, isOperateDb, label, gridLayoutItemList.length, newGridLayoutItemList.length, isOuter);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFormInfoByBundleCallback(bundleName, typeId, isOuter);
      } catch (error) {
        log.showError('deleteGridLayoutItemByBundleNameAndType with error %{public}s', error.message);
      }
    }
  }

  /**
   * 根据卡片id删除卡片
   *
   * @param id 卡片id
   * @param label 业务标识
   * @param isOperateDb true执行数据库操作
   * @param isOuter 判断是否外屏
   */
  deleteGridLayoutItemByItemId(id: string, label: string, isOperateDb: boolean = true, isOuter?: boolean): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let filter = (item: GridLayoutItemInfo): boolean => item.cardId !== id || item.typeId !== CommonConstants.TYPE_CARD;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    log.showInfo(`deleteCardItemByCardId with cardId %{public}s from %{public}s db：%{public}s, oldResult %{public}d, newResult %{public}d`,
      id, label, isOperateDb, gridLayoutItemList.length, newGridLayoutItemList.length);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);
    LauncherLayoutCacheUtil.changeLazyRotateSettings(newGridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFormByFormIdCallback(id, this.getAppItemListPage(newGridLayoutItemList), isOuter);
      } catch (error) {
        log.showInfo(`deleteCardItemByCardId with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 根据位置更新卡片信息
   */
  async updateGridLayoutItemByPosition(page: number, row: number, col: number, item: GridLayoutItemInfo, label: string,
    isOperateDb: boolean = true, isOuterDesktop?: boolean): Promise<RdbHandleResult> {
    let updateResult: RdbHandleResult = RdbHandleResult.CANCEL;
    log.showInfo('updateGridLayoutItemByPosition with page %{public}d, row %{public}d, col %{public}d from %{public}s db %{public}s',
      page, row, col, label, isOperateDb);
    if (CheckEmptyUtils.isEmpty(item) || item.typeId !== CommonConstants.TYPE_CARD) {
      log.showInfo('the item is null or type is error');
      return updateResult;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuterDesktop);
    // 清除外屏超出布局范围的卡片
    if (LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(item, isOuterDesktop)) {
      log.showInfo('this item is outer from out of layoutBound');
      gridLayoutItemList?.filter(layoutItem => {
        return layoutItem.cardId !== item.cardId;
      });
      this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuterDesktop);
      return updateResult;
    }
    let layoutItem: GridLayoutItemInfo | undefined =
      gridLayoutItemList.find(item => item.page === page && item.row === row && item.column === col);
    if (!layoutItem) {
      log.showWarn('updateGridLayoutItemByPosition find the card failure');
      return updateResult;
    }
    let selectIndex = gridLayoutItemList.indexOf(layoutItem);
    gridLayoutItemList[selectIndex] = item;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuterDesktop);

    if (isOperateDb) {
      try {
        const res: boolean = await LauncherLayoutCacheUtil.updateFormPositionCallBack(item, isOuterDesktop);
        updateResult = res ? RdbHandleResult.SUCCESS : RdbHandleResult.FAIL;
      } catch (error) {
        log.showError(`updateGridLayoutItemByPosition with error %{public}s`, error.message);
      }
    }
    return updateResult;
  }

  /**
   * 更新卡片尺寸和位置
   */
  async updateFormSizeAndPosition(cardItem: CardItemInfo, label: string, isOuterDesktop?: boolean): Promise<void> {
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showError('card item is empty');
      return;
    }
    log.showInfo('updateFormSizeAndPosition with page %{public}d, row %{public}d, col %{public}d from %{public}s',
      cardItem.page, cardItem.row, cardItem.column, label);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuterDesktop);
    let layoutItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.cardId === cardItem.cardId);
    if (!layoutItem) {
      log.showError('cached layout item is empty');
      return;
    }
    layoutItem.row = cardItem.row;
    layoutItem.column = cardItem.column;
    layoutItem.area = cardItem.area;
    layoutItem.cardDimension = cardItem.cardDimension;
    layoutItem.cardId = '0';
    layoutItem.cardName = cardItem.cardName;

    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuterDesktop);
  }

  /**
   * 堆叠只剩一张卡，退化为卡片，更新缓存
   *
   * @param formStackInfo 需要删除的堆叠
   * @param remainingCard 退化成的那张卡
   */
  changeStackToCard(formStackInfo: GridLayoutItemInfo, remainingCard: GridLayoutItemInfo, isOuter?: boolean): void {
    if (!formStackInfo || !remainingCard) {
      log.showError('update last card fail, input param invalid');
      return;
    }

    remainingCard.page = formStackInfo.page;
    remainingCard.row = formStackInfo.row;
    remainingCard.column = formStackInfo.column;
    // 堆叠退化成单卡片时还原container
    remainingCard.container = CommonConstants.CONTAINER_DESKTOP;
    this.updateStackToCard(formStackInfo, remainingCard, isOuter);
    log.showInfo('update formstack remaining card done');
  }

  private updateStackToCard(deleteItem: GridLayoutItemInfo, formInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn('deleteGridLayoutItemById error with null deleteItem');
      return;
    }
    if (CheckEmptyUtils.isEmpty(formInfo)) {
      log.showWarn('updateFormItemInfoById error as the form is null');
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let filter = (item: GridLayoutItemInfo): boolean => !GridLayoutUtil.checkGridItemEqual(item, deleteItem);
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    newGridLayoutItemList.push(formInfo);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);

    try {
      LauncherLayoutCacheUtil.updateFormInfoByIdChange(formInfo as Object as CardItemInfo, isOuter);
    } catch (error) {
      log.showError('updateFormItemInfoById with error %{public}s', error?.message);
    }
    try {
      LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(deleteItem.infoId, [deleteItem.page], isOuter);
    } catch (error) {
      log.showError('deleteGridLayoutItemById with error %{public}s', error?.message);
    }
  }
  /**
   * 根据id更新堆叠item
   *
   * @param formStackItem 更新的item信息
   * @param label 业务的标识
   */
  updateFormStackItemById(formStackItem: GridLayoutItemInfo, label: string, isOuter?: boolean): void {
    if (!formStackItem) {
      log.showWarn(`updateFormStackItemById failure as the updateItem is null`);
      return;
    }
    log.showInfo(`updateFormStackItemById from id ${formStackItem.id} from ${label}`);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let selectIndex: number = gridLayoutItemList.findIndex(item => item.formStackId === formStackItem.formStackId);
    if (selectIndex < 0) {
      log.showWarn(`updateFormStackItemById cannot find item. key:${GridLayoutUtil.generateUniqueKey(formStackItem)}`);
      return;
    }
    gridLayoutItemList[selectIndex] = formStackItem;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
  }

  /**
   * 根据id更新卡片
   *
   * @param formInfo
   * @param label
   * @param isOperateDb
   */
  updateFormItemInfoById(formInfo: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(formInfo)) {
      log.showWarn('updateFormItemInfoById error as the form is null');
      return;
    }
    log.showInfo('updateFormItemInfoById bundleName: %{public}s, from %{public}s, db %{public}s',
      formInfo.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    gridLayoutItemList.push(formInfo);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateFormInfoByIdChange(formInfo as Object as CardItemInfo);
      } catch (error) {
        log.showError('updateFormItemInfoById with error %{public}s', error.message);
      }
    }
  }

  /**
   * 插入卡片到堆叠里
   *
   * @param updateItem 堆叠item
   * @param newFormItem 新加入的卡片
   * @param label 业务标识
   * @param isOperateDb isOperateDb true需要数据库操作，false不需要
   */
  insertFormToFormStack(updateItem: GridLayoutItemInfo, newFormItem: GridLayoutItemInfo[], label: string,
     isOperateDb: boolean = true, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(updateItem)) {
      log.showWarn(`insertFormToFormStack failure as the updateItem is null`);
      return;
    }
    log.showInfo(`insertFormToFormStack from id %{public}s from %{public}s, db: %{public}s`, updateItem.id, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let selectIndex: number = gridLayoutItemList.findIndex(item => item.formStackId === updateItem.formStackId);
    gridLayoutItemList[selectIndex] = updateItem;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.addInfoToFormStackCallBack(updateItem, newFormItem, isOuter);
      } catch (error) {
        log.showError(`updateGridLayoutItemById with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 添加一张卡片到桌面
   *
   * @param cardItem 卡片item
   * @param label 业务标识
   */
  addCardItemToDesktop(cardItem: CardItemInfo, label: string, isOperateDb: boolean = true, ctx?: SingleContext): void {
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showWarn('addCardItemToDesktop error as the card is null');
      return;
    }
    log.showInfo(`addCardItemToDesktop item bundleName %{public}s, from %{public}s db %{public}s`,
      cardItem.bundleName, label, isOperateDb);
    if (LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(cardItem)) {
      log.showInfo('cardItem is out of layoutBound from outer.');
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList;
    if (LauncherLayoutCacheUtil.getIsLazyRotate() && DeviceHelper.isBigScreenMachine()) {
      if (!LauncherLayoutCacheUtil.updateCardAnotherStatusPosition(gridLayoutItemList, cardItem)) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_CANT_ADD, null);
        log.showWarn('addCardItemToDesktop not addable');
        return;
      }
      const newItems: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache([cardItem as Object as GridLayoutItemInfo]);
      if (CheckEmptyUtils.isEmptyArr(newItems)) {
        log.showError('addCardItemToDesktop array empty');
        return;
      }
      cardItem = newItems[0] as Object as CardItemInfo;
    }
    cardItem = LauncherLayoutCacheUtil
      .updateListIfLazyRotateMode([cardItem as object as GridLayoutItemInfo], gridLayoutItemList, 'addCardItemToDesktop')[0] as Object as CardItemInfo;
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showInfo('convertFolderSize failure as the null item after LazyRotateMode!');
      return;
    }
    newGridLayoutItemList.push(cardItem as object as GridLayoutItemInfo);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList);
    LauncherLayoutCacheUtil.changeLazyRotateSettings(newGridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateFormInfoByIdChange(cardItem, undefined, ctx);
      } catch (error) {
        log.showError(`addCardItemToDesktop with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 插入堆叠到布局
   *
   * @param gridlayoutItem 堆叠item
   * @param label 业务标识
   * @param isOperateDb isOperateDb true需要数据库操作，false不需要
   */
  insertFormStackItemInfo(gridlayoutItem: GridLayoutItemInfo, cardListInfo: GridLayoutItemInfo[], label: string,
                          needInsertDbList: GridLayoutItemInfo[], isOperateDb: boolean = true, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showWarn(`insertFormStackItemInfo failure as the null item`);
      return;
    }
    log.showInfo(`insertFormStackItemInfo item FormStackId %{public}s, cards length %{public}d from %{public}s db: %{public}s`,
      gridlayoutItem.formStackId, cardListInfo.length, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    gridLayoutItemList.push(gridlayoutItem);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.insertNewFormStackInfoCallBack(gridlayoutItem, cardListInfo, needInsertDbList, isOuter);
      } catch (error) {
        log.showError(`insertFormStackItemInfo with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 更新卡片到堆叠
   *
   * @param formStack 堆叠
   * @param cardList 卡片列表
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateCardsFormDesktopToFormStack(formStack: GridLayoutItemInfo, cardList: GridLayoutItemInfo[], label: string,
                                    needInsertDbList: GridLayoutItemInfo[], isOperateDb: boolean, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(formStack) || CheckEmptyUtils.isEmptyArr(cardList)) {
      log.showWarn('updateCardsFormDesktopToFormStack error as the formStack is null');
      return;
    }
    log.showInfo('updateCardsFormDesktopToFormStack formStack %{public}s, form %{public}s, db: %{public}s',
      formStack.formStackId, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let formStackItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item =>
      item.typeId === CommonConstants.TYPE_FORM_STACK && item.formStackId === formStack.formStackId);
    if (!formStackItem) {
      log.showError('updateCardsFormDesktopToFormStack error as the formstack is not found');
      return;
    }
    formStackItem.layoutInfo = formStack.layoutInfo;

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToFormStackCallback(formStack, cardList, needInsertDbList, isOuter);
      } catch (error) {
        log.showError('updateCardsFormDesktopToFormStack error with %{public}s', error.message);
      }
    }
  }

  /**
   * 更新堆叠卡片中卡片的ID信息
   * @param formStackId 堆叠卡片ID
   * @param newCardId 待更新卡片的新ID
   * @param card 待更新卡片的信息
   * @param containerId 关联堆叠的ID
   */
  async updateCardIdOfFormStack(formStackId: string, newCardId: string, card: CardItemInfo,
      containerId: number, isOuter?: boolean): Promise<RdbHandleResult> {
    log.showWarn(`update newCardId: ${newCardId}, container: ${containerId}, bundleName: ${card.bundleName}.`);
    let updateResult: RdbHandleResult = RdbHandleResult.CANCEL;
    const oldCardId: string = card.cardId;
    let gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let formStackItem = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FORM_STACK &&
      item.formStackId === formStackId);
    if (!formStackItem || !formStackItem.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo[0])) {
      log.showError(`can not find formStackId: ${formStackId}.`);
      return updateResult;
    }

    const items: GridLayoutItemInfo[] = formStackItem.layoutInfo[0];
    const index: number = items.findIndex(item => {
      if (!CheckEmptyUtils.checkStrIsEmpty(oldCardId)) {
        return item.cardId === oldCardId && item.bundleName === card.bundleName;
      } else {
        return item.bundleName === card.bundleName;
      }
    });

    if (index < 0) {
      log.showError(`can not find item bundleName: ${card.bundleName}, index: ${index}.`);
      return updateResult;
    }

    card.cardId = newCardId;
    card.container = containerId;
    items[index].cardId = newCardId;
    items[index].container = containerId;
    if (card.extend1) {
      card.extend1 = Extend1Data.unsetMigrateForm(card.extend1);
      items[index].extend1 = Extend1Data.unsetMigrateForm(items[index].extend1 ?? '');
    }
    const res: boolean = await LauncherLayoutCacheUtil.updateCardIdOfFormStack(oldCardId, items[index], isOuter);
    updateResult = res ? RdbHandleResult.SUCCESS : RdbHandleResult.FAIL;
    return updateResult;
  }

  /**
   * 升级根据id更新卡片/堆叠缓存和数据库信息
   * @param remainingStackInfos 要保留的堆叠信息
   * @param deleteFormAndStackInfos 要删除的卡片和堆叠信息
   * @param label 业务标识
   * @param isOperateDb true 需要数据库操作，false 不需要
   */
  deleteSceneBoardFormAndStackInfos(remainingStackInfos: GridLayoutItemInfo[], deleteFormAndStackInfos: GridLayoutItemInfo[],
    label: string, isOperateDb: boolean = true): void {
    log.showInfo(`remainingStackInfos : ${remainingStackInfos.length} ,deleteFormAndStackInfos.length :
      ${deleteFormAndStackInfos.length} from business ${label}`);
    let gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList();
    // 过滤所有删除的ID
    let deleteFormAndStackIds: string[] = [];
    if (!CheckEmptyUtils.isEmptyArr(deleteFormAndStackInfos)) {
      deleteFormAndStackIds = deleteFormAndStackInfos.map(item => item.infoId ?? '');
    }
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => {
      return deleteFormAndStackIds.every((deleteFormAndStackId) => {
        return item.infoId !== deleteFormAndStackId;
      });
    });
    // 替换堆叠内容
    for (let remainingStackInfo of remainingStackInfos) {
      log.showInfo(`leftStackInfos : ${remainingStackInfo.formStackId} `);
      const stackIndex = newGridLayoutItemList.findIndex((item) => {
        return remainingStackInfo.formStackId === item.formStackId;
      });
      if (stackIndex === CommonConstants.INVALID_VALUE) {
        continue;
      }
      // 判断堆叠是否退化成卡片
      if (remainingStackInfo.layoutInfo?.[0]?.length === 1) {
        log.showInfo(`stack need to convert card : ${remainingStackInfo.formStackId} `);
        // 删除数据库堆叠
        deleteFormAndStackIds.push(remainingStackInfo.formStackId ?? '');
        // 堆叠退化成单卡片
        let remainingCard: GridLayoutItemInfo = remainingStackInfo.layoutInfo[0][0];
        remainingCard.page = remainingStackInfo.page;
        remainingCard.row = remainingStackInfo.row;
        remainingCard.column = remainingStackInfo.column;
        remainingCard.container = CommonConstants.CONTAINER_DESKTOP;
        // 修改数据库中单卡片的数据
        let newCard: CardItemInfo = ConvertUtil.gridLayoutToCard(remainingCard);
        LauncherLayoutCacheUtil.updateFormInfoByIdChange(newCard);
        // 替换缓存中的堆叠为卡片
        newGridLayoutItemList[stackIndex] = remainingCard;
      } else {
        newGridLayoutItemList[stackIndex] = remainingStackInfo;
      }
    }
    log.showInfo('deleteSceneBoardFormAndStackInfos oldResult %{public}d, newResult %{public}d',
      gridLayoutItemList.length, newGridLayoutItemList.length);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList);
    // 删除数据库
    if (isOperateDb) {
      try {
        RdbStoreManager.getInstance().deleteRelationFormInfoOfDb(deleteFormAndStackIds);
      } catch (error) {
        log.showError('deleteRelationFormInfoOfDb error with %{public}s', error.message);
      }
    }
  }

  isEmptyStack(formStackItem: GridLayoutItemInfo): boolean {
    return CheckEmptyUtils.isEmpty(formStackItem) || CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo) ||
    CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo?.[0]);
  }

  /**
   * 删除堆叠里的预置卡片
   *
   * @param deleteForm 删除的卡片
   * @param formStackId 堆叠id
   * @param label 业务标识
   * @param isOperateDb 数据库操作 true 需要数据库操作，false 不需要
   */
  deletePreloadFormInFormStack(deleteForm: GridLayoutItemInfo,
                               formStackId: string, label: string, isOperateDb: boolean = true, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(deleteForm)) {
      log.showError('deletePreloadFormInFormStack error as the deleteForm is empty');
      return;
    }
    log.showInfo('deletePreloadFormInFormStack with formStackId %{public}s from %{public}s db %{public}s',
      formStackId, label, isOperateDb);
    let gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let stackFilter = (item: GridLayoutItemInfo): boolean => item.formStackId === formStackId;
    let formStackItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(stackFilter);
    if (!formStackItem || this.isEmptyStack(formStackItem) || !formStackItem.layoutInfo) {
      log.showWarn('can not find the formStack by id %{public}s or the layout is empty', formStackId);
      return;
    }
    let cardFilter = (item: GridLayoutItemInfo): boolean => item.bundleName !== deleteForm.bundleName &&
      item.cardName !== deleteForm.cardName;
    let layoutListInFormStack: GridLayoutItemInfo[] = formStackItem.layoutInfo[0];
    layoutListInFormStack = layoutListInFormStack.filter(cardFilter);
    formStackItem.layoutInfo[0] = layoutListInFormStack;

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFormInFormStackByNameAndContainer(deleteForm, formStackItem.id ?? 0);
      } catch (error) {
        log.showError('deleteRelationFormInfoOfDb error with %{public}s', error.message);
      }
    }
  }

  /**
   * 更新卡片和堆叠信息
   * @param relationCards 需要修改的卡片信息
   * @param label 业务标识
   * @param isOperateDb true 需要数据库操作，false 不需要
   */
  updateFormAndStackInfos(relationCards: CardItemInfo[], label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    log.showInfo(`updateFormAndStackInfos, relationCards.length : ${relationCards.length} from business ${label}` +
      `isOuter: ${isOuter}`);
    if (CheckEmptyUtils.isEmptyArr(relationCards)) {
      return;
    }
    let allFormAndStackInfos = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (let i = 0; i < allFormAndStackInfos.length; i++) {
      if (allFormAndStackInfos[i].typeId === CommonConstants.TYPE_CARD) {
        LauncherLayoutCacheUtil.updateCardLayoutInfo(relationCards, allFormAndStackInfos[i]);
      } else if (allFormAndStackInfos[i].typeId === CommonConstants.TYPE_FORM_STACK) {
        for (let j = 0; j < allFormAndStackInfos[i].layoutInfo?.[0].length; j++) {
          LauncherLayoutCacheUtil.updateCardLayoutInfo(relationCards, allFormAndStackInfos[i].layoutInfo[0][j],
            allFormAndStackInfos[i]);
        }
      }
    }
    // 修改数据库
    if (isOperateDb) {
      try {
        RdbStoreManager.getInstance().updateRelationFormInfoOfDb(relationCards, isOuter);
      } catch (error) {
        log.showError('deleteRelationFormInfoOfDb error with %{public}s', error.message);
      }
    }
  }

  /**
   * 检查堆叠是否合法，并清除脏数据
   * @param formStackInfo
   * @param stackId
   *
   * @returns boolean
   */
  private checkAndDealDirtyStack(formStackInfo: GridLayoutItemInfo | undefined, stackId: string): boolean {
    if (!formStackInfo || !formStackInfo.layoutInfo) {
      log.showWarn(`no formstack(${stackId}) in cache`);
      return false;
    }

    if (CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo[0])) {
      log.showError(`formstack(${stackId}) has no card, delete it`);
      this.deleteGridLayoutItemById(formStackInfo, BusinessType.BUSINESS_CARD, true);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      return false;
    }

    if (formStackInfo.layoutInfo[0].length < FORMSTACK_CARDS_MIN_LEN) {
      let cardInfo: GridLayoutItemInfo = formStackInfo.layoutInfo[0][0];
      log.showError(`only one card(${cardInfo.cardId}) in stack(${stackId}), change to card`);
      this.changeStackToCard(formStackInfo, cardInfo);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      return false;
    }

    return true;
  }
}