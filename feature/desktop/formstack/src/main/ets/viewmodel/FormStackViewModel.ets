/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import Prompt from '@ohos.promptAction';
import type ctx from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import {
  EventConstants,
  CommonConstants,
  BaseViewModel,
  FormModel,
  FormCommonUtil,
  FormLayoutCacheManager,
  Extend1Data,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  ReceiveEventInfo,
} from '@ohos/launchercommon';
import type { CardItemInfo } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, ResourceManager, AccessibilityManager, localEventManager } from '@ohos/frameworkwrapper';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import { FormStackEventIdUtil } from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import type { DragItemPosition } from '@ohos/componentdrag';
import { FormStackStyleConstants } from '../common/FormStackStyleConstants';
import { FormStackModel } from '../common/FormStackModel';
import type {
  FormStackCreateEvent,
  FormStackAddCardEvent,
  FormStackCollapseEvent,
  FormStackMoveEvent,
  DragSubCardToDesktopEvent,
} from '../common/FormStackHiSysEventUtil';
import { FormStackHiSysEventUtil } from '../common/FormStackHiSysEventUtil';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackConstants } from '../common/FormStackConstants';
import { formStackSnapShowManager } from '../common/FormStackSnapShowManager';

const TAG: string = 'FormStackViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
export interface AddInterfaceExtendParam {
  isNeedAnimate: boolean;
  targetCardId?: string;
  isAppendFromTail?: boolean;
}
export enum FormStackMsgType {
  CREATE = 'createStack',
  ADD = 'add',
  DELETE = 'delete',
  SWAP = 'swap',
  SEARCH = 'search',
}

// 空函数
function noop(): void {};

export class FormStackViewModel extends BaseViewModel {
  public readonly mFormStackModel: FormStackModel;
  public readonly mFormLayoutManager: FormLayoutCacheManager;
  public readonly mFormModel: FormModel;
  private readonly mContext: ctx.ServiceExtensionContext;
  private readonly mAccessibilityManager: AccessibilityManager = AccessibilityManager.getInstance();

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
      if (event === EventConstants.EVENT_REQUEST_FORM_STACK_DELETE) {
        this.removeFormFromFormStack(params, launcherStatusUtil.getShowOutLauncherStatus());
      }
    }
  };

  static isSupportFormStack(): boolean {
    return FormStackExpandConfig.isSupportFormStack();
  }

  constructor() {
    super();
    this.mFormStackModel = new FormStackModel();
    this.mFormModel = FormModel.getInstance();
    this.mContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    this.mFormLayoutManager = FormLayoutCacheManager.getInstance();
    this.registerFormStackChangedListener();
  }

  public registerFormStackChangedListener(): void {
    localEventManager.registerEventListener(this.mLocalEventListener, [
      EventConstants.EVENT_REQUEST_FORM_STACK_DELETE
    ]);
    log.showInfo('registerFormStackChangedListener listener on create');
  }

  public async removeFormFromFormStack(bundleName: string, isOuter?: boolean): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showInfo(`remove form from stack failed, bundleName: ${bundleName}!`);
      return;
    }

    log.showInfo(`start to remove form from stack, bundleName: ${bundleName}.`);
    let formStackList: GridLayoutItemInfo[] = this.mFormStackModel.getFormStackList(isOuter);
    formStackList.forEach((item) => {
      let deleteCards: string[] = [];
      item?.layoutInfo?.[0].forEach((cardInfo: GridLayoutItemInfo) => {
        if (cardInfo.bundleName === bundleName) {
          log.showInfo(`delete card, formstackId: ${item.formStackId}, cardId: ${cardInfo.cardId}`);
          deleteCards.push(cardInfo.cardId ?? '');
        }
      });
      if (deleteCards.length > 0) {
        // 堆叠卡片卸载时不在当前页，不使用动效过渡
        this.deleteCardsFromFormStack(item.formStackId ?? '', deleteCards, FormStackUtil.isTargetItemInCurPage(item.page), isOuter);
      }
    });
  }

  public addNewFormStack(cards: GridLayoutItemInfo[], endLayoutInfo: GridLayoutItemInfo, isNeedAnimate: boolean = false,
    isBackToFormStack: boolean = false, isOuter?: boolean): boolean {
    if (FormStackUtil.isInvalidFormStackList(cards) || !endLayoutInfo) {
      log.showError(`add new formstack failed, cards len: ${cards?.length} or endLayoutInfo is invalid!`);
      return false;
    }

    const cardIds: string[] = cards.map(item => item?.cardId ?? '');
    log.showWarn('add new formstack, cards: %{public}s, endLayoutInfo: %{public}s, isNeedAnimate: %{public}s',
      String(cardIds), endLayoutInfo.cardId, isNeedAnimate);

    if (this.isDuplicateCardExist(cards)) {
      log.showError('duplicate card exist, create new formstack fail!');
      return false;
    }

    // 用户拖拽形成堆叠, 需要等落位动效执行完毕，再进行缓存操作
    if (!isNeedAnimate) {
      this.createFormStackWithoutAnimation(cards, cardIds, endLayoutInfo, false, !isBackToFormStack, isOuter);
      return true;
    }

    // 不在同一内外屏，直接形成堆叠，无需动画
    if (launcherStatusUtil.getShowOutLauncherStatus() !== isOuter) {
      log.showInfo('not same screen, create formstack no need animation.');
      this.createFormStackWithoutAnimation(cards, cardIds, endLayoutInfo, undefined, false, isOuter);
      return true;
    }

    // 组件不在当前页，直接形成堆叠，无需动画
    if (!FormStackUtil.isTargetItemInCurPage(endLayoutInfo.page, isOuter)) {
      log.showInfo('not in cur page, create formstack no need animation.');
      this.createFormStackWithoutAnimation(cards, cardIds, endLayoutInfo, undefined, false, isOuter);
      return true;
    }

    let formStackId: string = '';
    const card: CardItemInfo = endLayoutInfo as Object as CardItemInfo;
    const formId: string = FormCommonUtil.getFormComponentId(card);
    FormStackUtil.snapImage(formId, (pixmap) => {
      if (FormStackUtil.isValidImage(pixmap)) {
        log.showInfo(`snap formId: ${formId} success and valid!`);
        ResourceManager.getInstance().setAppResourceCache(formId, 'cardSnapshot', pixmap);
        formStackSnapShowManager.notifyShowSnapImgMsg(true, formId, card.cardDimension, endLayoutInfo);

        formStackId = this.createFormStack(cards, endLayoutInfo, false, isOuter);
        FormStackManager.getInstance().cacheFormStackIdInAnimate(formStackId);
        log.showInfo(`cache formStackId: ${formStackId} with animate.`);
        this.printInterfaceLog(FormStackMsgType.CREATE, formStackId, cardIds);

        setTimeout(() => {
          this.sendRefreshEvent(isOuter);
        }, FormStackConstants.WAIT_FORM_SNAP_IMAGE_SHOW_MS);

        setTimeout(() => {
          this.notifyCreateFormStackAnimate(formStackId);
        }, FormStackConstants.WAIT_FORM_STACK_REFRESH_MS);
      } else {
        // 截图无效导致无法使用遮罩过渡，直接形成堆叠
        log.showError('form snap image is empty when creating formstack!');
        this.createFormStackWithoutAnimation(cards, cardIds, endLayoutInfo, undefined, false, isOuter);
      }
    }, (error) => {
      // 截图异常不影响堆叠形成，保障基本功能正常
      log.showError('form snap image failed when creating formstack!');
      this.createFormStackWithoutAnimation(cards, cardIds, endLayoutInfo, undefined, false, isOuter);
    });
    return true;
  }

  public addCardsToFormStack(formStackId: string | undefined, cards: GridLayoutItemInfo[],
    extendParam?: AddInterfaceExtendParam, isOuter?: boolean): boolean {
    if (CheckEmptyUtils.isEmptyArr(cards) || !formStackId) {
      log.showError('card info or formStackId is null, add form to formstack failed!');
      return false;
    }

    const cardIds: string[] = cards.map(item => item?.cardId ?? '');
    log.showWarn('add cards to form stack, formStackId: %{public}s, cards: %{public}s, isNeedAnimate: %{public}s, ' +
      'targetCardId: %{public}s, isAppendFromTail: %{public}s', formStackId, String(cardIds),
      extendParam?.isNeedAnimate, extendParam?.targetCardId, extendParam?.isAppendFromTail);

    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showError('formStackInfo is invalid or layoutInfo is invalid or layoutInfo is invalid');
      return false;
    }

    let layoutInfo: GridLayoutItemInfo[] = formStackInfo.layoutInfo[0];
    if (this.isShowPromptView(layoutInfo.length + cards.length, isOuter)) {
      log.showWarn(`formStack ${formStackId} can not have more cards!`);
      return false;
    }
    if (this.isExistCardInList(layoutInfo, cards)) {
      log.showError('add cards failed, exist card in formStack!');
      return false;
    }

    const needInsertDbList: GridLayoutItemInfo[] =
      cards.filter(item =>!this.mFormLayoutManager.selectGridLayoutItemByItem(item, isOuter));
    cards.forEach((item: GridLayoutItemInfo) => item.page = layoutInfo[0].page);
    this.deleteCardLayoutItems(cards, isOuter);
    this.insertCardsToSpecificPosition(layoutInfo, cards, extendParam);
    this.mFormLayoutManager.updateCardsFormDesktopToFormStack(formStackInfo, cards, BusinessType.BUSINESS_CARD,
      needInsertDbList, true, isOuter);
    this.printInterfaceLog(FormStackMsgType.ADD, formStackId, cardIds);
    this.reportAddCardEvent(formStackInfo, cards[0]);
    if (extendParam?.isNeedAnimate) {
      this.notifyAddCardsToFormStackMsg(formStackId, cards, extendParam);
    }

    if (this.mAccessibilityManager.getIsAccessibilityMode()) {
      let name: string = FormStackUtil.updateName(cards[0] as object as CardItemInfo);
      this.mAccessibilityManager.sendTextAnnouncedForAccessibility(
        ResUtils.getInnerStringNumS($r('app.string.add_form_stack_text'), `${name}`), 'textAnnouncedForAddFormStack');
    }
    return true;
  }

  public deleteCardsFromFormStackForAI(formStackId: string | undefined, cardIds: string[],
    isNeedAnimate: boolean = false, isOuter?: boolean, removeDelay = 0): boolean {
    return this.deleteCardsFromFormStack(formStackId, cardIds, isNeedAnimate, isOuter, removeDelay, false)
  }

  public deleteCardsFromFormStack(formStackId: string | undefined, cardIds: string[],
    isNeedAnimate: boolean = false, isOuter?: boolean, removeDelay = 0, isNeedDelFrameForm: boolean = true): boolean {
    if (!formStackId || CheckEmptyUtils.isEmptyArr(cardIds)) {
      log.showError(`delete form from formstack failed, formStackId: ${formStackId}, cards len: ${cardIds?.length}!`);
      return false;
    }

    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showWarn('Desktop have not formStack.');
      return false;
    }

    let cardInfoList: GridLayoutItemInfo[] = formStackInfo.layoutInfo[0];
    const currentCardIds: string[] = cardInfoList.map(item => item.cardId ?? '');
    log.showWarn('delete cards from form stack, stackId: %{public}s, cards: %{public}s, isNeedAnimate: %{public}s,' +
      'currentList: %{public}s.', formStackId, String(cardIds), isNeedAnimate, String(currentCardIds));

    // 堆叠不在当前页，直接移除，无需动画
    if (isNeedAnimate && !FormStackUtil.isTargetItemInCurPage(formStackInfo.page)) {
      log.showInfo('not in cur page, delete card no need animation.');
      isNeedAnimate = false;
    }
    let isDeleteOuterCardInInner = isOuter && !launcherStatusUtil.getShowOutLauncherStatus();
    if (isNeedAnimate && isDeleteOuterCardInInner) {
      log.showInfo('isDeleteOuterCardInInner, no need animation.');
      isNeedAnimate = false;
    }

    const remainCards = this.deleteCards(cardInfoList, cardIds, isNeedAnimate,
      isOuter, removeDelay, isNeedDelFrameForm);
    if (remainCards.length === 0) {
      log.showWarn(`no card left in form stack: ${formStackId}, delete form stack!`);
      // 卡片全部删除
      this.deleteFormStackItemById(formStackInfo, isOuter);
      // 外屏刷新了，isDeleteOuterCardInInner 设置false，防止外屏重复刷新
      isDeleteOuterCardInInner &&= !isOuter;
      this.sendRefreshEvent(isOuter);
    } else if (remainCards.length === 1) {
      log.showInfo(`only one card left in form stack: ${formStackId}, delete form stack!`);
      this.updateRemainingCard(formStackInfo, remainCards[0], isOuter);
      if (isNeedAnimate) {
        this.notifyDeleteCardMsg(formStackId, cardIds, isNeedAnimate);
      } else {
         // 外屏刷新了，isDeleteOuterCardInInner 设置false，防止行外屏重复刷新
        isDeleteOuterCardInInner &&= !isOuter;
        this.sendRefreshEvent(isOuter);
      }
    } else {
      log.showInfo(`more than one card left in form stack: ${formStackId}`);
      formStackInfo.layoutInfo[0] = remainCards;
      this.mFormLayoutManager.updateFormStackItemById(formStackInfo, BusinessType.BUSINESS_CARD, isOuter);
      this.notifyDeleteCardMsg(formStackId, cardIds, isNeedAnimate);
    }
    if (isDeleteOuterCardInInner) {
      log.showInfo('isDeleteOuterCardInInner send EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH, null);
    }

    this.printInterfaceLog(FormStackMsgType.DELETE, formStackId, cardIds);
    return true;
  }

  private sendRefreshEvent(isOuter?: boolean): void {
    if (isOuter === undefined) {
      isOuter = false;
    }

    localEventManager.sendLocalEventSticky(isOuter ? EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH :
      EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH, null);
  }

  public swapCardToTopOfFormStack(formStackId: string, cardId: string, isNeedAnimate: boolean = false,
    isOuter?: boolean): boolean {
    log.showWarn(`swap card: ${cardId} to top of form stack: ${formStackId}, isNeedAnimate: ${isNeedAnimate}.`);
    let formInfoList: GridLayoutItemInfo[] = this.getFormLayoutInfoList(formStackId, isOuter);
    if (CheckEmptyUtils.isEmptyArr(formInfoList)) {
      log.showError(`no layout info of formstack Id: ${formStackId}!`);
      return false;
    }

    this.swapItemToTopOfList(formInfoList, cardId);
    let formStackInfo: GridLayoutItemInfo | null = this.updateLayoutInfo(formStackId, formInfoList, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo)) {
      log.showError('can not find this formstack!');
      return false;
    }

    // 堆叠不在当前页，直接置顶卡片，无需动画
    if (isNeedAnimate && !FormStackUtil.isTargetItemInCurPage(formStackInfo.page)) {
      log.showInfo('not in cur page, swap card no need animation.');
      isNeedAnimate = false;
    }

    this.printInterfaceLog(FormStackMsgType.SWAP, formStackId, [cardId]);
    this.notifyUpdateFormStackListMsg(formStackId, formInfoList, cardId, isNeedAnimate);
    return true;
  }

  public swapFormStackCard(formStackId: string, cardId1: string, cardId2: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(cardId1) || CheckEmptyUtils.checkStrIsEmpty(cardId2)) {
      log.showError(`cardId1: ${cardId1} or cardId2: ${cardId2} is invalid!`);
      return;
    }

    let formInfoList: GridLayoutItemInfo[] = this.getFormLayoutInfoList(formStackId, isOuter);
    if (CheckEmptyUtils.isEmptyArr(formInfoList) ) {
      log.showError(`layout info of form stack: ${formStackId} is invalid!`);
      return;
    }

    this.swapForm(formInfoList, cardId1, cardId2);
    this.updateLayoutInfo(formStackId, formInfoList, isOuter);
    this.notifyUpdateFormStackListMsg(formStackId, formInfoList, '', false);
  }

  public deleteCardCache(formStackId: string, cardId: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId) || CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      log.showError(`delete card cache failed, cardId: ${cardId} or formStackId: ${formStackId} is invalid!`);
      return;
    }

    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
    CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showWarn('Desktop have not the formStack');
      return;
    }

    let cardInfoList: GridLayoutItemInfo[] = formStackInfo.layoutInfo[0];
    log.showInfo(`start to delete card cache, cardId: ${cardId}, cards length: ${cardInfoList.length}.`);
    let index: number = cardInfoList.findIndex(item => item.cardId === cardId);
    if (index < 0) {
      log.showError('The card to be deleted does not exist in the formstack list!');
      return;
    }

    if (cardInfoList.length !== FormStackStyleConstants.FORM_STACK_CARD_MIN_NUM) {
      this.deleteCardDetail(cardInfoList, formStackId, cardId, isOuter);
      return;
    }
    let remainingCard: GridLayoutItemInfo[] = cardInfoList.filter(item => item.cardId !== cardId);
    if (CheckEmptyUtils.isEmptyArr(remainingCard)) {
      log.showError('remain card empty.');
      return;
    }

    this.updateRemainingCard(formStackInfo, remainingCard[0], isOuter);
  }

  public onDisplayChanged(formStackId: string, display: boolean, displayTime: number, isOuter?: boolean): void {
    if (display) {
      return;
    }

    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showError('DeskTop has not formStack');
      return;
    }

    const event: FormStackCollapseEvent = {
      formStackID: formStackId,
      area: formStackInfo.area ?? [],
      page: formStackInfo.page ?? -1,
      column: formStackInfo.column ?? -1,
      row: formStackInfo.row ?? -1,
      cardNum: formStackInfo.layoutInfo[0].length,
      expandedTime: String(displayTime),
      sourceType: Extend1Data.getCardSourceType(formStackInfo.extend1),
    };
    FormStackHiSysEventUtil.reportCollapse(event);
  }

  public reportFormStackDragEvent(dragItemType: number, dragItemInfo: GridLayoutItemInfo, origin: DragItemPosition,
                                  target: DragItemPosition, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(dragItemInfo) || CheckEmptyUtils.isEmpty(origin) || CheckEmptyUtils.isEmpty(target)) {
      log.showError('reportFormStackDragEvent, params is invalid');
      return;
    }
    if (dragItemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      let event: FormStackMoveEvent = {
        formStackID: dragItemInfo.formStackId as string,
        area: dragItemInfo.area ?? [],
        startPage: origin.page,
        startColumn: origin.column,
        startRow: origin.row,
        endPage: target.page,
        endColumn: target.column,
        endRow: target.row,
        sourceType: Extend1Data.getCardSourceType(dragItemInfo.extend1),
      };
      FormStackHiSysEventUtil.reportMoveEvent(event);
      return;
    }

    if (dragItemType === CommonConstants.DRAG_FROM_FORM_STACK && dragItemInfo.typeId === CommonConstants.TYPE_CARD) {
      this.reportDragSubCardToDesktop(dragItemInfo, target, isOuter);
    }
  }

  public notifyCloseFormStackExpandView(formStackId: string): void {
    log.showInfo(`notify form stack edit view clolse msg, formStackId: ${formStackId}.`);
    if (CheckEmptyUtils.isEmpty(formStackId)) {
      log.showError('notify close form stack edit view failed, formStackId is invalid!');
      return;
    }

    this.mContext?.eventHub?.emit(FormStackEventIdUtil.getShowFormNameEventId(formStackId));
  }

  public updateDesktop(): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  public notifyLastFormShow(cardId: string): void {
    this.mContext?.eventHub?.emit(`formStackClosed${cardId}`, cardId);
    log.showInfo(`notify last card[${cardId}] to show.`);
  }

  public delPreloadCardInFormStack(formStackId: string | undefined, card: CardItemInfo | undefined,
    isOuter?: boolean): void {
    if (!formStackId || !card) {
      log.showError('del preload card failed, formStackId empty or card invalid!');
      return;
    }

    // 删除缓存与db数据
    this.mFormLayoutManager.deletePreloadFormInFormStack(card as object as GridLayoutItemInfo,
      formStackId, BusinessType.BUSINESS_CARD, true, isOuter);

    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showError('formstack is not exist or layoutInfo empty!');
      return;
    }

    let cardInfoList: GridLayoutItemInfo[] = formStackInfo.layoutInfo[0];
    if (CheckEmptyUtils.isEmpty(cardInfoList)) {
      log.showError('formstack layoutInfo invalid!');
      return;
    }

    if (cardInfoList.length === 0) {
      log.showWarn(`no card left in form stack: ${formStackId}, delete form stack!`);
      // 卡片全部删除
      this.deleteFormStackItemById(formStackInfo, isOuter);
      this.sendRefreshEvent(isOuter);
    } else if (cardInfoList.length === 1) {
      log.showInfo(`only one card left in form stack: ${formStackId}, delete form stack!`);
      this.updateRemainingCard(formStackInfo, cardInfoList[0], isOuter);
      this.sendRefreshEvent(isOuter);
    } else {
      log.showInfo(`more than one card left in form stack: ${formStackId}`);
      this.notifyDelPreloadCardMsg(formStackId, `${card.bundleName}${card.cardName}`);
    }
  }

  public dragCardBackToFormStack(isOuter?: boolean): void {
    let position: number[] = FormStackManager.getInstance().getFormStackPosition();
    if (CheckEmptyUtils.isEmptyArr(position) || position.length < FormStackConstants.FORMSTACK_POS_ARRAY_LEN) {
      log.showError('formstack position info invalid!');
      return;
    }

    let dragItemInfo: GridLayoutItemInfo = AppStorage.get('dragItemInfo') as GridLayoutItemInfo;
    if (CheckEmptyUtils.isEmpty(dragItemInfo) || dragItemInfo.typeId !== CommonConstants.TYPE_CARD) {
      log.showError('drag item is not card!');
      return;
    }

    log.showWarn(`drag card back to formstack, the pos is : ${String(position)}`);
    let itemInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectGridLayoutItemByPosition(position[0], position[1], position[2], isOuter);
    if (!itemInfo) {
      log.showError('can not find valid item by this position!');
      return;
    }

    if (itemInfo.typeId === CommonConstants.TYPE_CARD) {
      // 重新形成堆叠
      this.addNewFormStack([itemInfo, dragItemInfo], itemInfo, undefined, true, isOuter);
    } else if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      // 重新加入堆叠
      this.addCardsToFormStack(itemInfo.formStackId ?? '', [dragItemInfo], undefined, isOuter);
      const addCardsMsgId: string = FormStackEventIdUtil.getAddCardsToFormStackEventId(itemInfo.formStackId);
      this.mContext?.eventHub?.emit(addCardsMsgId, [dragItemInfo]);
    } else {
      log.showWarn('typeId is not card or formstack, do not deal.');
      return;
    }
    this.sendRefreshEvent(isOuter);
  }

  public deleteCardsImmediately(cardIds: string[], isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(cardIds)) {
      log.showError('delete cards array empty!');
      return;
    }

    cardIds.forEach(item => {
      this.mFormModel.deleteFormById(item, false, isOuter, 0);
    });
  }

  private createNewFormStackInfo(cardListInfo: GridLayoutItemInfo[],
                                 endLayoutInfo: GridLayoutItemInfo): GridLayoutItemInfo {
    let formStackInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    formStackInfo.infoId = new Date().getTime().toString();
    formStackInfo.formStackId = new Date().getTime().toString();
    formStackInfo.layoutInfo = [];
    formStackInfo.typeId = CommonConstants.TYPE_FORM_STACK;
    formStackInfo.area = endLayoutInfo.area;
    formStackInfo.page = endLayoutInfo.page;
    formStackInfo.column = endLayoutInfo.column;
    formStackInfo.row = endLayoutInfo.row;
    formStackInfo.landscapePage = endLayoutInfo.landscapePage;
    formStackInfo.landscapeColumn = endLayoutInfo.landscapeColumn;
    formStackInfo.landscapeRow = endLayoutInfo.landscapeRow;
    formStackInfo.portraitPage = endLayoutInfo.portraitPage;
    formStackInfo.portraitColumn = endLayoutInfo.portraitColumn;
    formStackInfo.portraitRow = endLayoutInfo.portraitRow;
    formStackInfo.layoutInfo.push(cardListInfo);
    return formStackInfo;
  }

  private deleteCardLayoutItems(cardLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    for (let i = 0; i < cardLayoutInfo.length; i++) {
      this.mFormLayoutManager.deleteGridLayoutItemById(cardLayoutInfo[i], BusinessType.BUSINESS_CARD, false, isOuter);
    }
  }

  private reportCreateEvent(formStackInfo: GridLayoutItemInfo, cardListInfo: GridLayoutItemInfo[],
                            endLayoutInfo: GridLayoutItemInfo): void {
    let dragLayoutInfo: GridLayoutItemInfo | undefined;
    for (let i = 0; i < cardListInfo.length; i++) {
      if (cardListInfo[i].cardId !== endLayoutInfo.cardId) {
        dragLayoutInfo = cardListInfo[i];
        break;
      }
    }

    if (!dragLayoutInfo) {
      return;
    }
    log.showInfo(`dragLayoutInfo extend1: ${dragLayoutInfo.extend1}, endLayoutInfo extend1: ${endLayoutInfo.extend1}`);
    let event: FormStackCreateEvent = {
      dragItemPackageName: dragLayoutInfo.bundleName,
      endItemPackageName: endLayoutInfo.bundleName,
      formStackID: formStackInfo.formStackId ?? '',
      area: formStackInfo.area ?? [],
      screenPage: formStackInfo.page ?? -1,
      column: formStackInfo.column ?? -1,
      row: formStackInfo.row ?? -1,
      dragSourceType: Extend1Data.getCardSourceType(dragLayoutInfo.extend1),
      overSourceType: Extend1Data.getCardSourceType(endLayoutInfo.extend1),
    };
    FormStackHiSysEventUtil.reportCreateFormStack(event);
  }

  private reportAddCardEvent(formStackInfo: GridLayoutItemInfo, dragLayoutInfo: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showWarn('formStackInfo is invalid or layoutInfo is invalid');
      return;
    }

    let event: FormStackAddCardEvent = {
      dragItemPackageName: dragLayoutInfo.bundleName,
      totalNum: formStackInfo.layoutInfo[0].length,
      formStackID: formStackInfo.formStackId ?? '',
      area: formStackInfo.area ?? [],
      screenPage: formStackInfo.page ?? -1,
      column: formStackInfo.column ?? -1,
      row: formStackInfo.row ?? -1,
      dragSourceType: Extend1Data.getCardSourceType(dragLayoutInfo.extend1),
    };
    FormStackHiSysEventUtil.reportAddCard(event);
  }

  private reportDragSubCardToDesktop(dragItemInfo: GridLayoutItemInfo, target: DragItemPosition,
    isOuter?: boolean): void {
    let formStackId: string | undefined = AppStorage.get<string>('formStackId');
    if (formStackId === undefined) {
      log.showError('report drag sub-card to desktop failed, form stack id is null.');
      return;
    }
    const origin: DragItemPosition | undefined = FormStackManager.getInstance().getDragOriginPosition();
    if (origin === undefined) {
      log.showError('report drag sub-card to desktop failed, there is no origin position.');
      return;
    }
    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showWarn('formStackInfo is invalid or layoutInfo is invalid');
      return;
    }

    let num: number = CheckEmptyUtils.isEmpty(formStackInfo) ? 0 : formStackInfo.layoutInfo[0].length;
    let event: DragSubCardToDesktopEvent = {
      formStackID: formStackId,
      area: dragItemInfo.area ?? [],
      page: origin.page,
      column: origin.column,
      row: origin.row,
      dragCardPackageName: dragItemInfo.bundleName,
      endPage: target.page,
      endColumn: target.column,
      endRow: target.row,
      cardNum: num,
      dragSourceType: Extend1Data.getCardSourceType(dragItemInfo.extend1),
    };
    FormStackHiSysEventUtil.reportDragSubCardToDesktop(event);
  }

  private isExistCardInList(itemList: GridLayoutItemInfo[], addCards: GridLayoutItemInfo[]): boolean {
    let cardIs: Set<string> = new Set<string>();
    itemList.forEach(item => {
      cardIs.add(item?.cardId as string);
    });

    for (let i: number = 0; i < addCards.length; i++) {
      if (cardIs.has(addCards[i]?.cardId ?? '')) {
        return true;
      }
    }

    return false;
  }

  private getFormLayoutInfoList(formStackId: string, isOuter?: boolean): GridLayoutItemInfo[] {
    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showWarn('Desktop have not the formStack');
      return [];
    }

    return formStackInfo?.layoutInfo?.[0];
  }

  private swapForm(formItemList: GridLayoutItemInfo[], cardId1: string, cardId2: string): void {
    let idx1: number = -1;
    let idx2: number = -1;

    for (let idx: number = 0; idx < formItemList.length; idx++) {
      if (cardId1 === formItemList[idx].cardId) {
        idx1 = idx;
      }

      if (cardId2 === formItemList[idx].cardId) {
        idx2 = idx;
      }

      if (idx1 >= 0 && idx2 >= 0) {
        break;
      }
    }

    if (idx1 < 0 || idx2 < 0) {
      log.showInfo(`swap form [${cardId1}, ${cardId2}] failed!`);
      return;
    }

    let item: GridLayoutItemInfo = formItemList[idx1];
    formItemList[idx1] = formItemList[idx2];
    formItemList[idx2] = item;
    log.showInfo(`swap form [${cardId1}, ${cardId2}] succeed.`);
  }

  private updateLayoutInfo(formStackId: string, formItemList: GridLayoutItemInfo[], isOuter?: boolean):
    GridLayoutItemInfo | null {
    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showError(`update layout info failed, formStackId: ${formStackId}!`);
      return null;
    }

    formStackInfo.layoutInfo[0] = formItemList;
    this.mFormLayoutManager.updateFormStackItemById(formStackInfo, BusinessType.BUSINESS_CARD, isOuter);
    return formStackInfo;
  }

  private notifyDeleteCardMsg(formStackId: string, cardIds: string[], isNeedAnimate: boolean = false): void {
    log.showWarn('notify delete card msg, formStackId: %{public}s, cardIds: %{public}s, isNeedAnimate: %{public}s.',
      formStackId, String(cardIds), isNeedAnimate);
    const eventId: string = FormStackEventIdUtil.getDelCardsOfFromStackEventId(formStackId);
    this.mContext?.eventHub?.emit(eventId, cardIds, isNeedAnimate);
  }

  private notifyDelPreloadCardMsg(formStackId: string, key: string): void {
    log.showWarn('notify delete preload card msg, formStackId: %{public}s, key: %{public}s.', formStackId, key);
    const eventId: string = FormStackEventIdUtil.getDelPreloadCardOfFsEventId(formStackId);
    this.mContext?.eventHub?.emit(eventId, key);
  }

  private notifyUpdateFormStackListMsg(formStackId: string, cards: GridLayoutItemInfo[],
                                       topCardId: string, isNeedAnimate: boolean): void {
    log.showInfo(`notify update form stack data msg, formStackId: ${formStackId}.`);
    const eventId: string = FormStackEventIdUtil.getUpdateFormStackEventId(formStackId);
    this.mContext?.eventHub?.emit(eventId, cards, topCardId, isNeedAnimate);
  }

  private notifyAddCardsToFormStackMsg(formStackId: string, cards: GridLayoutItemInfo[],
                                       extend: AddInterfaceExtendParam): void {
    log.showInfo(`notify add cards to form stack msg, stackId: ${formStackId}, isNeedAnimate: ${extend.isNeedAnimate}.`);
    const eventId: string = FormStackEventIdUtil.getAddCardsToFormStackEventId(formStackId);
    this.mContext?.eventHub?.emit(eventId, cards, extend);
  }

  private notifyCreateFormStackAnimate(formStackId: string): void {
    log.showInfo(`notify create form stack animate, formStackId: ${formStackId}.`);
    const eventId: string = FormStackEventIdUtil.getCreateFormStackAnimateEventId(formStackId);
    this.mContext?.eventHub?.emit(eventId);
  }

  private isShowPromptView(formCount: number, isOuter?: boolean): boolean {
    if ((!isOuter && formCount <= FormStackStyleConstants.FORM_STACK_CARD_MAX_NUM) ||
      (isOuter && formCount <= FormStackStyleConstants.OUTER_FORM_STACK_CARD_MAX_NUM)) {
      return false;
    }

    try {
      Prompt.showToast({
        message: $r('app.string.form_stack_max_number_limit'),
      });
    } catch (error) {
      log.showError(`prompt error: ${error?.code}!`);
    }

    return true;
  }

  private swapItemToTopOfList(formInfoList: GridLayoutItemInfo[], cardId: string): void {
    let index: number = formInfoList.findIndex(item => item.cardId === cardId);
    if (index < 0) {
      log.showError(`swap card to top failed, can not find cardId: ${cardId}!`);
      return;
    }

    let itemList: GridLayoutItemInfo[] = formInfoList.splice(0, index + 1);
    formInfoList.push(...itemList);
  }

  private deleteCardDetail(cardInfoList: GridLayoutItemInfo[], formStackId: string, cardId: string, isOuter?: boolean):
    boolean {
    let index: number = cardInfoList.findIndex(item => item.cardId === cardId);
    if (index < 0) {
      log.showError(`card: ${cardId} is not exist in this formstack: ${formStackId}!`);
      return false;
    }

    cardInfoList.splice(index, 1);
    let formStackInfo: GridLayoutItemInfo | undefined =
      this.mFormLayoutManager.selectFormStackItemByFormStackId(formStackId, isOuter);
    if (!formStackInfo || CheckEmptyUtils.isEmpty(formStackInfo) || !formStackInfo.layoutInfo ||
      CheckEmptyUtils.isEmptyArr(formStackInfo.layoutInfo)) {
      log.showError('Desktop have not the formStack');
      return false;
    }

    formStackInfo.layoutInfo[0] = cardInfoList;
    this.mFormLayoutManager.updateFormStackItemById(formStackInfo, BusinessType.BUSINESS_CARD, isOuter);
    this.notifyDeleteCardMsg(formStackId, [cardId]);
    log.showInfo('delete card done.');
    return true;
  }

  private updateRemainingCard(formStackInfo: GridLayoutItemInfo, remainingCard: GridLayoutItemInfo, isOuter?: boolean):
    void {
    this.mFormLayoutManager.changeStackToCard(formStackInfo, remainingCard, isOuter);
    FormStackManager.getInstance().deleteFormStackCards(formStackInfo.formStackId ?? '');
  }

  private insertCardsToSpecificPosition(cardList: GridLayoutItemInfo[], addCards: GridLayoutItemInfo[],
                                        extendParam?: AddInterfaceExtendParam): number {
    if (!extendParam) {
      cardList.push(...addCards);
      return cardList.length - addCards.length - 1;
    }

    log.showWarn('add cards to specific position, targetCardId: %{public}s, isAppendFromTail: %{public}s.',
      extendParam.targetCardId, extendParam.isAppendFromTail);
    const index: number = cardList.findIndex(item => item.cardId === extendParam.targetCardId);
    if (index < 0 || (index === cardList.length - 1 && extendParam.isAppendFromTail)) {
      log.showInfo(`find index: ${index}, just append cards from tail!`);
      cardList.push(...addCards);
      return cardList.length - addCards.length - 1;
    }

    const insertIndex: number = extendParam?.isAppendFromTail ? index + 1 : index;
    const tailCards = cardList.splice(insertIndex);
    cardList.push(...addCards);
    cardList.push(...tailCards);

    return insertIndex;
  }

  private deleteCards(cardInfoList: GridLayoutItemInfo[], cardIds: string[],
    isNeedAnimate: boolean, isOuter?: boolean, removeDelay = 0, isNeedDelFrameForm = true): GridLayoutItemInfo[] {
    const setCardIds: Set<string> = new Set<string>();
    cardIds.forEach(item => {
      setCardIds.add(item);
      // 移除走动效时，删卡放在动效结束后执行
      if (!isNeedAnimate) {
        this.mFormModel.deleteFormById(item, false, isOuter, removeDelay, isNeedDelFrameForm);
      } else {
        // 无论要不要走动画，直接删除数据库中的数据
        this.mFormModel.deleteFormByIdAsync(item, true, isNeedDelFrameForm);
      }
    });

    return cardInfoList.filter(item => !setCardIds.has(item.cardId ?? ''));
  }

  private createFormStack(cards: GridLayoutItemInfo[], endLayoutInfo: GridLayoutItemInfo, needToWait = false,
    isOuter?: boolean): string {
    const needInsertDbList: GridLayoutItemInfo[] =
      cards.filter(item => !this.mFormLayoutManager.selectGridLayoutItemByItem(item, isOuter));
    cards.forEach((item: GridLayoutItemInfo) => item.page = endLayoutInfo.page);
    const formStackInfo: GridLayoutItemInfo = this.createNewFormStackInfo([...cards], endLayoutInfo);
    // 等待创建堆叠的通知
    if (needToWait) {
      const MAX_WAIT_DURATION = 1000;
      // 先移除拖拽的那张卡片
      this.deleteCardLayoutItems(cards.filter(
        (item: GridLayoutItemInfo) => !GridLayoutUtil.checkGridItemEqual(item, endLayoutInfo)), isOuter);
      let execFunction: () => void = () => {
        // 由于存在页数删除，endLayoutInfo的页数可能有变化，因此需要找出此时endLayoutInfo所在的page
        const latestEndLayoutInfo: GridLayoutItemInfo | undefined =
          LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(endLayoutInfo, isOuter);
        if (latestEndLayoutInfo) {
          formStackInfo.page = latestEndLayoutInfo.page;
        }
        // 再移除落位点的那张卡片
        this.deleteCardLayoutItems(
          cards.filter((item: GridLayoutItemInfo) => GridLayoutUtil.checkGridItemEqual(item, endLayoutInfo)), isOuter);
        this.mFormLayoutManager.insertFormStackItemInfo(formStackInfo, [...cards], BusinessType.BUSINESS_CARD,
          needInsertDbList, true, isOuter);
        this.mContext?.eventHub?.off(EventConstants.CREATE_FORM_STACK_NOTIFY_EVENT, callBack);
        clearTimeout(timeId);
        // 防止定时器没clear, 置空execFunction, 保证只执行一次
        execFunction = noop;
      };
      const callBack: () => void = () => {
        execFunction();
      };
      this.mContext?.eventHub?.on(EventConstants.CREATE_FORM_STACK_NOTIFY_EVENT, callBack);
      let timeId = setTimeout(callBack, MAX_WAIT_DURATION);
    } else {
      this.deleteCardLayoutItems(cards, isOuter);
      this.mFormLayoutManager.insertFormStackItemInfo(formStackInfo, [...cards], BusinessType.BUSINESS_CARD,
        needInsertDbList, true, isOuter);
    }
    this.reportCreateEvent(formStackInfo, cards, endLayoutInfo);

    return formStackInfo.formStackId ?? '';
  }

  private printInterfaceLog(type: FormStackMsgType, formStackId: string, cards: string[], isOuter?: boolean): void {
    const cardList: string[] = this.getFormLayoutInfoList(formStackId, isOuter)?.map(item => item.cardId ?? '');
    log.showWarn('after iface called: %{public}s cards: %{public}s of stackId: %{public}s, cardList: %{public}s.', type,
      String(cards), formStackId, String(cardList));
  }

  private isDuplicateCardExist(cards: GridLayoutItemInfo[]): boolean {
    let cardKeys: Set<string> = new Set<string>(cards.map(item => `${item.bundleName}${item.cardId}`));
    log.showInfo(`check duplicate card, total len: ${cards.length}, valid len: ${cardKeys.size}`);
    return cards.length !== cardKeys.size;
  }

  private createFormStackWithoutAnimation(cards: GridLayoutItemInfo[], cardIds: string[],
    endLayoutInfo: GridLayoutItemInfo, isAiCommand: boolean = true, needToWait = false, isOuter?: boolean): void {
    const stackId: string = this.createFormStack(cards, endLayoutInfo, needToWait, isOuter);
    this.printInterfaceLog(FormStackMsgType.CREATE, stackId, cardIds);
    if (this.mAccessibilityManager.getIsAccessibilityMode()) {
      let name: string = FormStackUtil.updateName(cards[0] as object as CardItemInfo);
      let endName: string = FormStackUtil.updateName(endLayoutInfo as object as CardItemInfo);
      this.mAccessibilityManager.sendTextAnnouncedForAccessibility(
        ResUtils.getInnerStringNumS($r('app.string.create_form_stack_text'), `${name}`, `${endName}`), 'textAnnouncedForCreatFormStack');
    }
    // 语音助手服务推送才需要立即刷新桌面，用户拖拽形成不触发
    if (isAiCommand) {
      this.sendRefreshEvent(isOuter);
    }
  }

  private deleteFormStackItemById(formStackInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    //堆叠完全销毁的时候，再去清理缓存
    this.mFormLayoutManager.deleteGridLayoutItemById(formStackInfo, BusinessType.BUSINESS_CARD, true, isOuter);
    FormStackManager.getInstance().deleteFormStackCards(formStackInfo.formStackId ?? '');
  }
}