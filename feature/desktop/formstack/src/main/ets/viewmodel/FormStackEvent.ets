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

import curves from '@ohos.curves';
import { image } from '@kit.ImageKit';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  localEventManager,
  GlobalContext,
  ResourceManager,
  LightOutdoorConfig,
  AccessibilityManager
} from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { animateExBreak, animateExDelete, animateExGet, animateExToImmediately } from '@ohos/windowscene/Index';
import {
  CardItemInfo,
  Extend1Data,
  editModeManager,
  FormCommonUtil,
  desktopItemDraggableManager,
  DesktopDragResult
} from '@ohos/launchercommon';
import { FormStackEventIdUtil } from '@ohos/launchercommon';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { EventConstants } from '@ohos/launchercommon';
import { FormRelationManager } from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene';
import {
  FormStackHiSysEventUtil,
  ShortcutMenuClickEvent,
  ShortcutMenuClickItem
} from '../common/FormStackHiSysEventUtil';
import { FormStackItemInfo } from '../common/FormStackItemInfo';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackManager } from '../common/FormStackManager';
import { formStackSnapShowManager } from '../common/FormStackSnapShowManager';
import { FormStackAnimate } from './FormStackAnimate';
import { FormStackMsgType, FormStackViewModel, AddInterfaceExtendParam } from './FormStackViewModel';
import { FormStackAnimateItem } from './FormStackAnimateItem';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';

const TAG: string = 'FormStackEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const OPACITY_ANIMATE_TIME_DURATION_MS: number = 300;

export interface EventCallback {
  coverdFormStack: (isShow: boolean) => void;
  dropStackCard: (cards: GridLayoutItemInfo[], dragResult: DesktopDragResult) => void;
  openFormStackByMenu: () => void;
  updateFormStack: (itemList: CardItemInfo[]) => void;
  formStackDropEnd: () => void;
  showFormName: () => void;
  formNameAnimate: (cardId: string, isDisappear?: boolean, callback?: () => void) => void;
  clearDropAnimateParam: () => void;
  resetFormStack: () => void;
};

/**
 * 堆叠场景卡动效标识命名
 * 1)推荐使用可打断的动效接口animateExToImmediately
 * 2)onFinish回调中需要调用animateExDelete删除已执行动效对象
 */
enum FormStackAnimType {
  // 创建堆叠
  CREATE_FORMSTACK,
  // 设置卡片透明度
  SET_CARD_OPACITY,
  // 删除非顶部卡片
  DEL_CARD_NO_TOP,
  // 删除顶部卡片后剩一张卡片
  DEL_CARD_LEFT_ONE_ON_TOP,
  // 删除顶部卡片后剩多张卡片
  DEL_CARD_LEFT_STACK_ON_TOP,
  // 添加卡片到堆叠
  ADD_FORM,
  // 卡片置顶
  SWAP_CARD_TO_TOP,
}

export class FormStackEvent {
  public mDesktopContext: ServiceExtensionContext = GlobalContext.getContext();
  public mFormItemList: CardItemInfo[] = [];
  public mFormStackTopCardId: string = '';
  public mSlideFormIndex: number = 0;
  public mFormStackAnimate: FormStackAnimate = new FormStackAnimate();
  public mFormStackViewModel : FormStackViewModel = new FormStackViewModel();
  public mFormStackItem: FormStackItemInfo = new FormStackItemInfo();
  private mIsOuterDesktop: boolean = false;
  public mEventCallback: EventCallback = {
    coverdFormStack: () => { log.showError('no coverdFormStack func registered!'); },
    dropStackCard: () => { log.showError('no dropStackCard func registered!'); },
    openFormStackByMenu: () => { log.showError('no openFormStackByMenu func registered!'); },
    updateFormStack: (itemList) => { log.showError('no updateFormStack func registered!'); },
    formStackDropEnd: () => { log.showError('no formStackDropEnd func registered!'); },
    showFormName: () => { log.showError('no showFormName func registered!'); },
    formNameAnimate: (formId, isDisappear, callback) => { log.showError('no formNameAnimate func registered!'); },
    clearDropAnimateParam: () => { log.showError('no clearDropAnimateParam func registered!'); },
    resetFormStack: () => { log.showError('no resetFormStack func registered!'); },
  };

  public setDesktopStatus(isOuter?: boolean) {
    this.mIsOuterDesktop = isOuter === undefined ? false : isOuter;
  }

  private mUpdateFormStackEventCallback: Function = (cards: GridLayoutItemInfo[], topCardId: string,
    isNeedAnimate: boolean) => this.onUpdateFormStackEvent(cards, topCardId, isNeedAnimate);
  private mAddCardsEventCallback: Function = (cards: CardItemInfo[], extendParam?: AddInterfaceExtendParam) =>
    this.onAddCardsEvent(cards, extendParam);
  private mDeleteCardsEventCallback: Function = (cardIds: string[], isNeedAnimate: boolean = false) =>
    this.onDeleteCardsEvent(cardIds, isNeedAnimate);
  private mCreateFormStackAnimateEventCallback: Function = () => this.onCreateFormStackAnimateEvent();
  private mDelPreloadCardEventCallback: Function = (key: string) => this.onDelPreloadCard(key);
  // 堆叠动效类型标识
  private mAnimateNames: string[] = [];
  // 轮转卡片置顶动效
  private hasSwapCardToTopAnimate: boolean = false;

  public initData(formStackItem: FormStackItemInfo, itemList: CardItemInfo[], animate: FormStackAnimate): boolean {
    if (!formStackItem || CheckEmptyUtils.isEmptyArr(itemList) || !animate) {
      log.showError('form stack event init data failed, input is invalid!');
      return false;
    }

    this.mFormStackItem = formStackItem;
    this.mFormItemList = itemList;
    this.mFormStackAnimate = animate;

    this.updateTopCardId();
    this.initAnimateName();
    return true;
  }

  public resetData(): void {
    log.showInfo('formstack event reset data');
    this.breakAnimation();
    this.deleteAnimation();
    this.mFormItemList = [];
    this.mFormStackTopCardId = '';
    this.mSlideFormIndex = 0;
    FormStackManager.getInstance().deleteFormStackIdInAnimate(this.mFormStackItem.formStackId ?? '');
  }

  public initEventMsg(callback: EventCallback): boolean {
    if (!this.mDesktopContext || !callback ||
      CheckEmptyUtils.checkStrIsEmpty(this.mFormStackItem.formStackId)) {
      log.showInfo('init event msg failed, param is invalid!');
      return false;
    }

    this.mEventCallback = callback;
    const formStackId: string = this.mFormStackItem.formStackId as string;
    let eventId: string = FormStackEventIdUtil.getCoverdFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mEventCallback.coverdFormStack);

    eventId = FormStackEventIdUtil.getDropStackCardEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mEventCallback.dropStackCard);

    eventId = FormStackEventIdUtil.getFormStackDropEndEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mEventCallback.formStackDropEnd);

    eventId = FormStackEventIdUtil.getUpdateFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mUpdateFormStackEventCallback);

    eventId = FormStackEventIdUtil.getOpenFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mEventCallback.openFormStackByMenu);

    eventId = FormStackEventIdUtil.getShowFormNameEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mEventCallback.showFormName);

    eventId = FormStackEventIdUtil.getAddCardsToFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mAddCardsEventCallback);

    eventId = FormStackEventIdUtil.getDelCardsOfFromStackEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mDeleteCardsEventCallback);

    eventId = FormStackEventIdUtil.getCreateFormStackAnimateEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mCreateFormStackAnimateEventCallback);

    eventId = FormStackEventIdUtil.getDelPreloadCardOfFsEventId(formStackId);
    this.mDesktopContext.eventHub.on(eventId, this.mDelPreloadCardEventCallback);
    log.showInfo('form stack register event hub done.');

    return true;
  }

  public resetEventMsg(): void {
    log.showInfo('reset event msg.');
    const formStackId: string = this.mFormStackItem.formStackId as string;
    let eventId: string = FormStackEventIdUtil.getCoverdFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mEventCallback.coverdFormStack);

    eventId = FormStackEventIdUtil.getDropStackCardEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mEventCallback.dropStackCard);

    eventId = FormStackEventIdUtil.getFormStackDropEndEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mEventCallback.formStackDropEnd);

    eventId = FormStackEventIdUtil.getUpdateFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mUpdateFormStackEventCallback);

    eventId = FormStackEventIdUtil.getOpenFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mEventCallback.openFormStackByMenu);

    eventId = FormStackEventIdUtil.getShowFormNameEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mEventCallback.showFormName);

    eventId = FormStackEventIdUtil.getAddCardsToFormStackEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mAddCardsEventCallback);

    eventId = FormStackEventIdUtil.getDelCardsOfFromStackEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mDeleteCardsEventCallback);

    eventId = FormStackEventIdUtil.getCreateFormStackAnimateEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mCreateFormStackAnimateEventCallback);

    eventId = FormStackEventIdUtil.getDelPreloadCardOfFsEventId(formStackId);
    this.mDesktopContext.eventHub.off(eventId, this.mDelPreloadCardEventCallback);
  }

  public getAppName(card: CardItemInfo, callback: (name: string) => void): boolean {
    if (!card || !callback) {
      log.showError('get app name failed, input is invalid!');
      return false;
    }

    const appName: string = this.getAppNameFromCache(card);
    if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
      callback(appName);
      return true;
    }

    ResourceManager.getInstance().getAppNameWithCache(card.appLabelId, card.bundleName, card.moduleName, '',
      (formName: string): void => this.getCardNameWithCacheCallback(formName, card, callback));
    return true;
  }

  public updateAppName(cardId: string, newName: string, currentMenuName: string): boolean {
    const index: number = this.mFormItemList.findIndex(item => item.cardId === cardId);
    if (index < 0) {
      log.showError(`update app name failed, can not find cardId: ${cardId} in form list!`);
      return false;
    }

    log.showInfo('update app name: topCardId: %{public}s, currentCardId: %{public}s, newName: %{public}s,' +
      ' topName: %{public}s.', this.mFormStackTopCardId, cardId, newName, this.mFormItemList[index].appName);

    let cardInfoArr: CardItemInfo[] = FormStackManager.getInstance()
      .getFormStackSubCards(this.mFormStackItem.formStackId ?? '');
    let cardInfo: CardItemInfo | undefined = cardInfoArr.find(ele => ele.cardId === cardId);
    if (!cardInfo) {
      cardInfo = {} as CardItemInfo;
      cardInfo.cardId = cardId;
      cardInfoArr.push(cardInfo);
      log.showInfo(`add cardId: ${cardId}, appName: ${newName}.`);
    }
    cardInfo.appName = newName;

    // 语音助手建议卡片在顶层，且名字和当前显示的名字不一样，才去做动效
    if (this.mFormStackTopCardId === cardId && newName !== currentMenuName) {
      log.showWarn(`update appName: ${newName} of card: ${cardId}, start name animate.`);
      this.formNameAnimate(cardId);
    }

    return true;
  }

  public syncFormItemList(itemList: CardItemInfo[]): void {
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError(`itemList len is invalid!: ${itemList?.length}!`);
      return;
    }

    this.mFormItemList = itemList;
    this.updateTopCardId();
  }

  /**
   * 推送场景卡形成堆叠：D => ABD
   * event：蒙层上移
   * onFinish：AB透明度0->1渐变
   */
  public onCreateFormStackAnimateEvent(): void {
    log.showInfo('receive create form stack animate msg.');

    // 截图消失
    formStackSnapShowManager.notifyShowSnapImgMsg(false, '', 0);
    FormStackManager.getInstance().deleteFormStackIdInAnimate(this.mFormStackItem.formStackId ?? '');

    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop onCreateFormStackAnimateEvent func!');
      return;
    }

    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.CREATE_FORMSTACK]);
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.CREATE_FORMSTACK],
      {
        curve: curves.springMotion(0.35, 0.86),
      },
      () => {
        this.mFormStackAnimate.mMaskList[0].mIsOffsetY = true;
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.CREATE_FORMSTACK]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.CREATE_FORMSTACK]);
        this.mFormStackAnimate.resetFormStackStatus();
        this.setFormsOpacity(0, this.mSlideFormIndex - 1, 0);
        this.startFormsOpacityAnimate(0, this.mSlideFormIndex - 1, 1);
        this.printCardListLog(FormStackMsgType.CREATE, []);
      });
  }

  public emitMenuDisappearMsg(): void {
    this.mDesktopContext.eventHub.emit(FormStackConstants.EVENTHUB_FORMSTACK_MENU_DISAPPEAR);
  }

  public deleteFormFromStack(formInfo: CardItemInfo): void {
    const event: ShortcutMenuClickEvent = {
      type: ShortcutMenuClickItem.ITEM_REMOVE,
      formStackID: this.mFormStackItem.formStackId as string,
      area: this.mFormStackItem.area,
      topCardPackageName: formInfo.bundleName,
      sourceType: Extend1Data.getCardSourceType(formInfo.extend1),
      formType: FormCommonUtil.getFormType(formInfo.gameCardInfo),
    };
    FormStackHiSysEventUtil.reportClickShortcutMenu(event);
    // 无障碍模式下，不需要删除动效，否则下树慢会获取到历史焦点
    let isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    this.mFormStackViewModel.deleteCardsFromFormStack(this.mFormStackItem.formStackId,
      [formInfo.cardId], !isAccessibilityMode, this.mIsOuterDesktop);

    // 处理系统迁移场景SceneBoard卡片映射关系文件
    if (FormRelationManager.getInstance().isSceneBoardCard(formInfo.bundleName, formInfo.cardName)) {
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(formInfo.cardId);
    }
  }

  public getFormIfNeedCover(): CardItemInfo | undefined {
    return this.mFormItemList.length === FormStackConstants.FORM_STACK_ITEM_MIN_LEN ? this.mFormItemList[0] : undefined;
  }

  /**
   * 判断是否接受对应的手势
   *
   * @param gestureInfo 手势信息
   * @param event 手势事件
   * @returns 是否接受对应的手势
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (gestureInfo.type === GestureControl.GestureType.DRAG) {
      if (editModeManager.isInEditMode() &&
        !editModeManager.isDraggable(this.mFormStackItem as Object as GridLayoutItemInfo) ||
        !desktopItemDraggableManager.getEnableDrag()) {
        return GestureJudgeResult.REJECT;
      }
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
        return GestureJudgeResult.REJECT;
      }
    }
    return GestureJudgeResult.CONTINUE;
  }

  public onDisableFormClick(): void {
    this.mFormStackAnimate.disableFormClick();
  }

  private setFormsOpacity(start: number, end: number, opacity: number): void {
    const max: number = this.mFormStackAnimate?.mItemInfoList?.length || 0;
    for (let i = Math.max(0, start); i < Math.min(end, max); i++) {
      this.mFormStackAnimate.mItemInfoList[i].mOpacity = opacity;
    }
  }

  /**
   * 卡片透明度渐变动画
   *
   * @param start 起始卡片索引
   * @param end 截止卡片索引
   * @param opacity 透明度最终值
   */
  private startFormsOpacityAnimate(start: number, end: number, opacity: number): void {
    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop startFormsOpacityAnimate func!');
      return;
    }

    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.SET_CARD_OPACITY]);
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.SET_CARD_OPACITY],
      {
        duration: OPACITY_ANIMATE_TIME_DURATION_MS,
        curve: Curve.Sharp,
      },
      () => {
        this.setFormsOpacity(start, end, opacity);
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.SET_CARD_OPACITY]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.SET_CARD_OPACITY]);
      });
  }

  private formNameAnimate(formId: string, isDisappaer?: boolean, callback?: () => void): void {
    log.showInfo(`start appName animate of formId: ${formId}.`);
    this.mEventCallback.formNameAnimate(formId, isDisappaer, callback);
  }

  private onDeleteCardsEvent(cardIds: string[], isNeedAnimate: boolean = false): void {
    log.showWarn(`receive delete cards msg, isNeedAnimate: ${isNeedAnimate}`);
    if (CheckEmptyUtils.isEmptyArr(cardIds)) {
      log.showError(`delete cards msg handle failed, cardIds: ${String(cardIds)} is empty!`);
      return;
    }

    this.formStackSelfHealing();
    if (!this.isAllCardsExistInFormList(cardIds)) {
      log.showWarn(`delete cards msg handle warning, not all cardIds: ${cardIds} in formStack!`);
    }

    this.printCardListLog(FormStackMsgType.DELETE, cardIds);
    if (!isNeedAnimate) {
      this.deleteCardsWithNoAnimate(cardIds);
    } else {
      this.deleteCardsWithAnimate(cardIds);
    }
  }

  private deleteCardsWithNoAnimate(cardIds: string[]): void {
    log.showInfo('form stack delete cards with no animate.');
    this.deleteCardsOfFormList(cardIds);
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList)) {
      log.showError('cards len of form stack is invalid, refresh desktop layout.');
      this.sendRefreshEvent();
      return;
    }

    this.mFormStackAnimate.deleteFormOfFormStack(cardIds);
    this.formNameAnimate(this.mFormStackTopCardId);
    this.printCardListLog(FormStackMsgType.DELETE, cardIds);
  }

  private deleteCardsWithAnimate(cardIds: string[]): void {
    log.showInfo('form stack delete cards with animate.');
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList)) {
      log.showError(`form list len is invalid: ${this.mFormItemList.length}.`);
      return;
    }

    const itemLen: number = this.mFormItemList.length;
    const leftCardsLen: number = itemLen - cardIds.length;
    const topCardId: string = this.mFormItemList[itemLen - 1].cardId;
    const index: number = cardIds.findIndex(item => item === topCardId);
    if (index < 0) {
      this.deleteCardsWithNoCardOnTop(cardIds, leftCardsLen);
    } else {
      this.deleteCardWithOneCardOnTop(cardIds, leftCardsLen, topCardId);
    }
  }

  /**
   * 移除非顶部卡片
   * 场景一：ABC => BC 直接移除，不走动画
   * 场景二：ABC => C
   * event：蒙层+卡片下移渐隐
   * onFinish：顶部卡片使用过渡截图组件平替，等待堆叠下树完成
   *
   * @param cardIds 被移除卡片ID集
   * @param leftCardsLen 剩余卡片数量
   */
  private deleteCardsWithNoCardOnTop(cardIds: string[], leftCardsLen: number): void {
    log.showInfo(`delete cards: ${cardIds.toString()}, deleted cards is not on top.`);

    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop deleteCardsWithNoCardOnTop func!');
      return;
    }

    if (leftCardsLen >= FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      // 如果待删除卡片不在顶部, 且删完卡片后，卡片堆叠还存在
      this.mFormStackViewModel.deleteCardsImmediately(cardIds, this.mIsOuterDesktop);
      this.deleteCardsWithNoAnimate(cardIds);
    } else if (leftCardsLen > 0) {
      this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.DEL_CARD_NO_TOP]);
      animateExToImmediately(this.mAnimateNames[FormStackAnimType.DEL_CARD_NO_TOP],
        {
          curve: curves.springMotion(0.35, 0.86),
        },
        () => {
          const len: number = this.mFormStackAnimate.mItemInfoList.length;
          this.mFormStackAnimate.mItemInfoList.forEach((item, index) => {
            if (index !== len - 1) {
              item.mIsOffsetY = false;
              item.mOpacity = 0;
              item.mScaleX = 1;
              item.mScaleY = 1;
            }
          });
          this.mFormStackAnimate.mMaskList[0].mOpacity = 0;
          this.mFormStackAnimate.mMaskList[0].mIsOffsetY = false;
        },
        () => {
          log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.DEL_CARD_NO_TOP]}`);
          animateExDelete(this.mAnimateNames[FormStackAnimType.DEL_CARD_NO_TOP]);
          this.mFormStackViewModel.deleteCardsImmediately(cardIds, this.mIsOuterDesktop);
          this.sendRefreshEvent();
        });

      this.formNameAnimate(this.mFormItemList[this.mSlideFormIndex].cardId, true);
      this.printCardListLog(FormStackMsgType.DELETE, cardIds);
    } else {
      log.showWarn('delete all cards in form stack!');
    }
  }

  private sendRefreshEvent(): void {
    log.showInfo('send formstack refresh event');
    localEventManager.sendLocalEventSticky(this.mIsOuterDesktop ?
      EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH :
      EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH, null);
  }

  private deleteCardWithOneCardOnTop(cardIds: string[], leftCardsLen: number, topCardId: string): void {
    log.showInfo(`delete cards: ${String(cardIds)}, topCard: ${topCardId}, one card of deleted cards is on top.`);
    if (leftCardsLen >= FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      this.deleteCardsLeftStackWhenOneCardOnTop(cardIds, topCardId);
    } else if (leftCardsLen > 0) {
      this.deleteCardsLeftOneCardWhenOneCardOnTop(cardIds, topCardId);
    } else {
      log.showWarn('delete all cards in form stack!');
      this.mFormStackViewModel.deleteCardsImmediately(cardIds, this.mIsOuterDesktop);
    }
  }

  /**
   * 移除顶部卡片剩一张卡片：ABC => A
   * 1)中间卡片直接移除，无动画
   * 2)终态卡片状态准备
   * 3)堆叠退场动画
   * event：蒙层下移渐隐 + 顶卡渐隐
   * onFinish：底卡使用过渡截图组件平替，等待单卡加载完成
   *
   * @param cardIds 被移除卡片ID集
   * @param topCardId 顶卡ID
   */
  private deleteCardsLeftOneCardWhenOneCardOnTop(cardIds: string[], topCardId: string): void {
    log.showInfo(`delete cards with one card left, topCardId: ${topCardId}.`);
    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop deleteCardsLeftOneCardWhenOneCardOnTop func!');
      return;
    }

    // 优先移除位于堆叠中间位置的卡片
    const notTopCardIds: string[] = cardIds.filter(item => item !== topCardId);
    if (!CheckEmptyUtils.isEmptyArr(notTopCardIds)) {
      this.deleteCardsOfFormList(notTopCardIds);
      this.mFormStackAnimate.deleteFormOfFormStack(notTopCardIds);
    }

    // 底卡状态刷新+蒙层后移
    if (!this.mFormStackAnimate.mItemInfoList[0]) {
      this.logGetAnimateDataError();
      return;
    }
    this.mFormStackAnimate.initItemAsTopCard(this.mFormStackAnimate.mItemInfoList[0]);
    this.mFormStackAnimate.mMaskList[0].zIndex -= 2;

    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_ONE_ON_TOP]);
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_ONE_ON_TOP],
      {
        duration: OPACITY_ANIMATE_TIME_DURATION_MS,
        curve: Curve.Sharp,
      },
      () => {
        if (!this.mFormStackAnimate.mMaskList[0] || !this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex]) {
          this.logGetAnimateDataError();
          return;
        }
        this.mFormStackAnimate.mMaskList[0].mIsOffsetY = false;
        this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex].mOpacity = 0;
        this.mFormStackAnimate.mMaskList[0].mOpacity = 0;
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_ONE_ON_TOP]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_ONE_ON_TOP]);
        this.mFormStackViewModel.deleteCardsImmediately(cardIds, this.mIsOuterDesktop);
        this.sendRefreshEvent();
      });

    this.formNameAnimate(this.mFormItemList[0].cardId, true);
    this.printCardListLog(FormStackMsgType.DELETE, cardIds);
  }

  /**
   * 移除顶部卡片后剩多张：ABC => AB
   * 1)中间卡片直接移除，无动画
   * 2)终态卡片状态准备
   * 3)顶卡退场动画
   * event：渐隐
   * onFinish：数据同步
   *
   * @param cardIds 被移除卡片ID集
   * @param topCardId 顶卡ID
   */
  private deleteCardsLeftStackWhenOneCardOnTop(cardIds: string[], topCardId: string): void {
    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop deleteCardsLeftStackWhenOneCardOnTop func!');
      return;
    }

    // 优先移除位于堆叠中间位置的卡片
    const notTopCardIds: string[] = cardIds.filter(item => item !== topCardId);
    if (!CheckEmptyUtils.isEmptyArr(notTopCardIds)) {
      log.showInfo(`delete not top cards: ${notTopCardIds}.`);
      this.deleteCardsOfFormList(notTopCardIds);
      this.mFormStackAnimate.deleteFormOfFormStack(notTopCardIds);
    }

    // 预备顶卡状态刷新+蒙层后移
    if (!this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex - 1] || !this.mFormStackAnimate.mMaskList[0]) {
      this.logGetAnimateDataError();
      return;
    }
    this.mFormStackAnimate.initItemAsTopCard(this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex - 1]);
    this.mFormStackAnimate.mMaskList[0].zIndex -= 2;

    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_STACK_ON_TOP]);
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_STACK_ON_TOP],
      {
        duration: OPACITY_ANIMATE_TIME_DURATION_MS,
        curve: Curve.Sharp,
      },
      () => {
        if (!this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex]) {
          this.logGetAnimateDataError();
          return;
        }
        this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex].mOpacity = 0;
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_STACK_ON_TOP]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.DEL_CARD_LEFT_STACK_ON_TOP]);
        this.mFormStackViewModel.deleteCardsImmediately(cardIds, this.mIsOuterDesktop);
        this.deleteCardsOfFormList([topCardId]);
        this.mFormStackAnimate.deleteFormOfFormStack([topCardId]);
        this.printCardListLog(FormStackMsgType.DELETE, cardIds);
      });
    this.formNameAnimate(this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex - 1].formId);
  }

  private onAddCardsEvent(cards: CardItemInfo[], extendParam?: AddInterfaceExtendParam): void {
    if (CheckEmptyUtils.isEmptyArr(cards) || this.isCardExistInFormList(cards)) {
      log.showError(`add cards failed, cards len: ${cards?.length} invalid or some card is exist in form list!`);
      return;
    }

    this.formStackSelfHealing();
    const addCardIds: string[] = cards.map(item => item.cardId);
    log.showWarn('receive add cards msg, isNeedAnimate: %{public}s, targetCardId: %{public}s,',
      extendParam?.isNeedAnimate, extendParam?.targetCardId);
    this.printCardListLog(FormStackMsgType.ADD, addCardIds);

    if (!extendParam?.isNeedAnimate) {
      this.addFormsWithoutAnimate(cards);
    } else {
      this.addFormsWithAnimate(cards, extendParam);
    }
  }

  private printCardListLog(type: FormStackMsgType, cardIds: string[]): void {
    // 卡片数据列表
    const formList: string[] = this.mFormItemList.map(item => item.cardId);
    // 卡片视图列表
    const animateList: string[] = this.mFormStackAnimate.mItemInfoList.map(item => item.formId);
    log.showWarn('printCardListLog: %{public}s cards: %{public}s, formList: %{public}s, animateList: %{public}s.', type,
      String(cardIds), String(formList), String(animateList));
  }

  /**
   * 推送场景卡到堆叠
   * 场景一：AB => ACB 直接同步数据，无动画
   * 场景二：AB => ABC
   * event：顶卡渐显
   * onFinish：非顶卡渐显
   *
   * @param cards 新增卡片ID集
   * @param extendParam 拓展参数
   */
  private addFormsWithAnimate(cards: CardItemInfo[], extendParam: AddInterfaceExtendParam): void {
    log.showInfo('add forms isNeedAnimate: %{public}s, targetCardId: %{public}s, isAppendFromTail: %{public}s.',
      extendParam.isNeedAnimate, extendParam.targetCardId, extendParam.isAppendFromTail);
    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop addFormsWithAnimate func!');
      return;
    }

    const isAppendFromTail: boolean = extendParam.isAppendFromTail as boolean;
    const currentLen: number = this.mFormItemList.length;
    const isNeedAnimate: boolean = CheckEmptyUtils.checkStrIsEmpty(extendParam.targetCardId) ||
      (extendParam.targetCardId === this.mFormItemList[currentLen - 1].cardId && isAppendFromTail);

    const addCardIds: string[] = cards.map(item => item.cardId);
    this.addFormsInPlaceOfCard(cards, extendParam.targetCardId as string, isAppendFromTail);
    this.mFormStackAnimate.addFormsToFormStack(cards, extendParam.targetCardId, isAppendFromTail, isNeedAnimate);
    if (!isNeedAnimate) {
      this.printCardListLog(FormStackMsgType.ADD, addCardIds);
      log.showInfo('add forms with no animate!');
      return;
    }

    if (!this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex]) {
      this.logGetAnimateDataError();
      return;
    }
    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.ADD_FORM]);
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.ADD_FORM],
      {
        duration: OPACITY_ANIMATE_TIME_DURATION_MS,
        curve: Curve.Sharp,
      },
      () => {
        if (!this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex]) {
          this.logGetAnimateDataError();
          return;
        }
        this.mFormStackAnimate.mItemInfoList[this.mSlideFormIndex].mOpacity = 1;
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.ADD_FORM]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.ADD_FORM]);
        this.mFormStackAnimate.resetFormStackStatus();
        this.setFormsOpacity(0, this.mSlideFormIndex - 1, 0);
        this.startFormsOpacityAnimate(0, this.mSlideFormIndex - 1, 1);
        this.printCardListLog(FormStackMsgType.ADD, addCardIds);
      });
    this.formNameAnimate(this.mFormStackTopCardId);
  }

  private addFormsInPlaceOfCard(addCards: CardItemInfo[], cardId: string, isAddFromTail: boolean): void {
    const index: number = this.mFormItemList.findIndex(item => item.cardId === cardId);
    if (index < 0 || (index === this.mFormItemList.length - 1 && isAddFromTail)) {
      this.mFormItemList.push(...addCards);
    } else {
      const spliceIndex: number = isAddFromTail ? index + 1 : index;
      const spliceList: CardItemInfo[] = this.mFormItemList.splice(spliceIndex);
      this.mFormItemList.push(...addCards);
      this.mFormItemList.push(...spliceList);
    }

    this.updateTopCardId();
    this.mEventCallback.updateFormStack(this.mFormItemList);
  }

  private addFormsWithoutAnimate(cards: CardItemInfo[]): void {
    const currentLen: number = this.mFormItemList.length;
    this.mFormItemList.push(...cards);
    this.updateTopCardId();
    this.mEventCallback.updateFormStack(this.mFormItemList);

    this.mFormStackAnimate.addFormsToFormStack(cards, this.mFormItemList[currentLen - 1].cardId, true);
    this.mEventCallback.clearDropAnimateParam();
    this.formNameAnimate(this.mFormStackTopCardId);
    this.printCardListLog(FormStackMsgType.ADD, cards.map(item => item.cardId));
  }

  private onUpdateFormStackEvent(cards: GridLayoutItemInfo[], topCardId: string, isNeedAnimate: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(cards)) {
      log.showError('receive updateFormStack msg, param is invalid!');
      return;
    }

    this.formStackSelfHealing();
    const cardIds: string[] = cards.map(item => item.cardId as string);
    log.showWarn('receive update form stack msg, topCardId: %{public}s', topCardId);
    this.printCardListLog(FormStackMsgType.SWAP, cardIds);
    if (CheckEmptyUtils.checkStrIsEmpty(topCardId)) {
      this.updateFormList(cards);
    } else {
      this.swapFormToTopOfFormStack(topCardId, isNeedAnimate);
    }
  }

  private swapFormToTopOfFormStack(topCardId: string, isNeedAnimate: boolean): void {
    FormStackManager.getInstance().deleteFormStackIdInAnimate(this.mFormStackItem.formStackId ?? '');
    const index: number = this.mFormItemList.findIndex(item => item.cardId === topCardId);
    if (index < 0) {
      log.showError(`swap form to top failed, can not find topCardId: ${topCardId}.`);
      return;
    }

    if (index === this.mFormItemList.length - 1) {
      log.showInfo(`swap to top card: ${topCardId} is aready on top!`);
      return;
    }

    if (!CheckEmptyUtils.checkStrIsEmpty(topCardId)) {
      // 语音助手服务推送卡片置顶，换位前刷新堆叠卡状态
      this.mFormStackAnimate.resetFormStackStatus();
    }
    this.swapCardOfMiddlePostionToTop(index, isNeedAnimate);
  }

  /**
   * 推送卡片置顶：ABC => CAB
   * 1)置顶数据同步&卡片状态准备
   * 2)顶卡显示动画
   * event：顶卡下移&渐显
   * onFinish：堆叠数据刷新
   *
   * @param index 被置顶卡片索引
   * @param isNeedAnimate 是否需要动画
   */
  private swapCardOfMiddlePostionToTop(index: number, isNeedAnimate: boolean): void {
    log.showInfo(`swap form to top of form stack, swap index: ${index}.`);
    if (this.isDataListEmpty()) {
      log.showWarn('data empty, stop swapCardOfMiddlePostionToTop func!');
      return;
    }
    // 打断动效
    animateTo({
      duration: 0,
    }, () => {
      this.mFormStackAnimate.resetFormStackStatus();
    })
    const topCardId: string = this.mFormItemList[index].cardId;
    const animateList: FormStackAnimateItem[] = this.mFormStackAnimate.mItemInfoList;
    // 防止越界
    const mSlideFormIndex: number = Math.min(this.mSlideFormIndex, animateList.length - 1);
    index = Math.min(index, animateList.length - 1);
    const startZIndex: number = animateList[mSlideFormIndex].zIndex;
    for (let i: number = 0; i <= index; i++) {
      animateList[i].mOpacity = 0;
      animateList[i].zIndex = startZIndex + 2 * (i + 1);
      this.mFormStackAnimate.initItemAsTopCard(animateList[i]);
    }

    const itemList = this.mFormItemList.splice(0, index + 1);
    this.mFormItemList.push(...itemList);
    this.updateTopCardId();
    this.mEventCallback.updateFormStack(this.mFormItemList);
    this.formNameAnimate(this.mFormStackTopCardId);
    if (!isNeedAnimate) {
      this.mFormStackAnimate.resetFormStackStatus();
      this.printCardListLog(FormStackMsgType.SWAP, [topCardId]);
      return;
    }

    this.clearAnimateSkeleton(this.mAnimateNames[FormStackAnimType.SWAP_CARD_TO_TOP]);
    // 轮转卡片置顶
    this.hasSwapCardToTopAnimate = true;
    animateExToImmediately(this.mAnimateNames[FormStackAnimType.SWAP_CARD_TO_TOP],
      {
        duration: OPACITY_ANIMATE_TIME_DURATION_MS,
        curve: Curve.Friction,
        onFinish: () => {
          this.hasSwapCardToTopAnimate = false;
        }
      },
      () => {
        animateList[mSlideFormIndex].mIsOffsetY = false;
        animateList[index].mOpacity = 1;
      },
      () => {
        log.showInfo(`animation finish: ${this.mAnimateNames[FormStackAnimType.SWAP_CARD_TO_TOP]}`);
        animateExDelete(this.mAnimateNames[FormStackAnimType.SWAP_CARD_TO_TOP]);
        this.mFormStackAnimate.resetFormStackStatus();
        this.printCardListLog(FormStackMsgType.SWAP, [topCardId]);
      });
  }

  private updateFormList(cards: GridLayoutItemInfo[]): void {
    const cardItems: CardItemInfo[] = cards as object[] as CardItemInfo[];
    this.mFormItemList = [...cardItems];
    this.mFormStackItem.layoutInfo[0] = [...cardItems];
    this.mEventCallback.updateFormStack(this.mFormItemList);
  }

  private deleteCardsOfFormList(cardIds: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(this.mFormItemList)) {
      log.showError('form list empty, delete failed!');
      return;
    }

    const cardIdSet: Set<string> = new Set<string>(cardIds);
    this.mFormItemList = this.mFormItemList.filter(item => !cardIdSet.has(item.cardId));
    log.showWarn(`left cards length after filtering: ${this.mFormItemList.length}`);
    this.updateTopCardId();
    this.mEventCallback.updateFormStack(this.mFormItemList);
  }

  private updateTopCardId(): void {
    this.mSlideFormIndex = this.mFormItemList.length - 1;
    this.mFormStackTopCardId = this.mFormItemList[this.mSlideFormIndex].cardId;
  }

  private getAppNameFromCache(card: CardItemInfo): string {
    if (!AiSuggestionUtil.isVoiceAbilityForm(card.bundleName, card.abilityName)) {
      return '';
    }

    const formStackId: string = this.mFormStackItem.formStackId as string;
    let cardInfo: CardItemInfo | undefined = FormStackManager.getInstance()
      .getFormStackSubCards(formStackId).find(ele => ele.cardId === card.cardId);

    if (CheckEmptyUtils.checkStrIsEmpty(cardInfo?.appName)) {
      return ResUtils.getInnerString($r('app.string.aisuggestion_app_name'));
    }

    return cardInfo?.appName ?? '';
  }

  private getCardNameWithCacheCallback(name: string, topCard: CardItemInfo, callback: (name: string) => void): void {
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      log.showWarn('cache callback name is empty, use bundle label instead.');
      ResourceManager.getInstance().getBundleLabelWithCache(topCard.appLabelId, topCard.bundleName, topCard.moduleName,
        '', (formName: string): void => callback(formName));
    } else {
      callback(name);
    }
  }

  private isAllCardsExistInFormList(cardIds: string[]): boolean {
    const totalCardIds: Set<string> = new Set<string>(this.mFormItemList.map(item => item.cardId));
    for (let i: number = 0; i < cardIds.length; i++) {
      if (!totalCardIds.has(cardIds[i])) {
        log.showError(`card: ${cardIds[i]} not exist in formList!`);
        return false;
      }
    }

    return true;
  }

  private logGetAnimateDataError(): void {
    const len: number = this.mFormStackAnimate.mItemInfoList.length;
    const mLen: number = this.mFormStackAnimate.mMaskList.length;
    log.showWarn(`get animateData fail; mSlideFormIndex = ${this.mSlideFormIndex};animateData = ${len};mask = ${mLen}`);
  }

  private isCardExistInFormList(cards: CardItemInfo[]): boolean {
    const cardIdList: string[] = this.mFormItemList.map(item => item.cardId);
    const cardIdSet: Set<string> = new Set<string>(cardIdList);
    for (let i: number = 0; i < cards.length; i++) {
      if (cardIdSet.has(cards[i].cardId)) {
        log.showError(`cardId: ${cards[i].cardId} exist in form list: ${String(cardIdList)}!`);
        return true;
      }
    }

    return false;
  }

  private onDelPreloadCard(key: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(key)) {
      log.showError('delete preload card fail, del key empty!');
      return;
    }

    this.mFormItemList = this.mFormItemList.filter(item => `${item.bundleName}${item.cardName}` !== key);
    this.updateTopCardId();
    this.mEventCallback.updateFormStack(this.mFormItemList);
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList)) {
      log.showError('cards len of form stack is invalid, refresh desktop layout.');
      this.sendRefreshEvent();
      return;
    }

    this.mFormStackAnimate.delPreloadCard(key);
    this.formNameAnimate(this.mFormStackTopCardId);
  }

  private initAnimateName(): void {
    const formStackId: string = this.mFormStackItem.formStackId as string;
    this.mAnimateNames = [
      `${formStackId}onCreateFormStackAnimateEvent`,
      `${formStackId}startFormsOpacityAnimate`,
      `${formStackId}deleteCardsWithNoCardOnTop`,
      `${formStackId}deleteCardsLeftOneCardWhenOneCardOnTop`,
      `${formStackId}deleteCardsLeftStackWhenOneCardOnTop`,
      `${formStackId}addFormsWithAnimate`,
      `${formStackId}swapCardOfMiddlePostionToTop`,
    ];
  }

  public breakAnimation(breakDeleteAnimation: boolean = true, callback?: () => void): void {
    let breakAnimationNames: string[] = this.mAnimateNames;
    if (!breakDeleteAnimation) {
      breakAnimationNames = this.mAnimateNames.filter((name: string) => {
        return !name.includes('delete');
      })
    }
    log.showInfo(`break animation names: ${breakAnimationNames.join('_')}`);
    breakAnimationNames.forEach((name: string) => {
      animateExBreak(name, 'break by formstack disappear.');
    });
    // 当前存在轮转置顶卡片动效，打断后重置堆叠顺序
    if (this.hasSwapCardToTopAnimate) {
      this.hasSwapCardToTopAnimate = false;
      callback?.();
    }
  }

  private deleteAnimation(): void {
    log.showInfo('formstack disappear, delete all animation');
    this.mAnimateNames.forEach(name => {
      animateExDelete(name);
    });
  }

  private isDataListEmpty(): boolean {
    return CheckEmptyUtils.isEmptyArr(this.mFormItemList) ||
      CheckEmptyUtils.isEmptyArr(this.mFormStackAnimate.mItemInfoList) ||
      CheckEmptyUtils.isEmptyArr(this.mFormStackAnimate.mMaskList);
  }

  /**
   * 堆叠数据缓存<->视图缓存自同步
   */
  private formStackSelfHealing(): void {
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList) ||
      FormStackUtil.isInvalidFormStackList(this.mFormStackAnimate.mItemInfoList)) {
      log.showError('data or view list invalid!');
      return;
    }

    // 增删改操作前先还原堆叠视图状态
    this.mEventCallback.resetFormStack();

    this.printCardListLog(FormStackMsgType.SEARCH, []);
    if (this.mFormItemList.length !== this.mFormStackAnimate.mItemInfoList.length) {
      log.showError('data and view list length does not match!');
      return;
    }

    let viewList: FormStackAnimateItem[] = this.mFormStackAnimate.mItemInfoList;
    this.mFormItemList.forEach((item) => {
      let idx: number = viewList.findIndex(viewItem => viewItem.formId === item.cardId);
      if (idx < 0) {
        // 卡片ID不匹配，查找脏数据位置，修正viewItem
        let targetIndex: number = this.getDirtyViewItemIndex(this.mFormItemList, viewList);
        if (targetIndex >= 0) {
          log.showWarn(`the card does not match: data id: ${item.cardId}, view id: ${viewList[targetIndex].formId}`);
          let cloneItem: FormStackAnimateItem =
            ObjectCopyUtil.deepClone(viewList[targetIndex], new FormStackAnimateItem());
          cloneItem.formId = item.cardId;
          cloneItem.bundleName = item.bundleName;
          cloneItem.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${item.bundleName}_${item.cardId}`;
          viewList[targetIndex] = cloneItem;
          if (item.cardId === this.mFormStackTopCardId) {
            this.formNameAnimate(this.mFormStackTopCardId);
          }
        }
      }
    });
  }

  /**
   * 获取viewList脏数据位置索引
   * @param cardList 数据列表
   * @param viewList 视图列表
   * @returns 目标索引
   */
  private getDirtyViewItemIndex(cardList: CardItemInfo[], viewList: FormStackAnimateItem[]): number {
    for (let i: number = 0; i < viewList.length; i++) {
      if (cardList.findIndex(card => card.cardId === viewList[i].formId) < 0) {
        // 查找到第一个脏数据即可返回
        return i;
      }
    }

    return -1;
  }

  private clearAnimateSkeleton(name: string): void {
    if (!CheckEmptyUtils.isEmpty(animateExGet(name))) {
      log.showWarn(`animate skeleton exist: ${name}`);
      animateExDelete(name);
    }
  }
}