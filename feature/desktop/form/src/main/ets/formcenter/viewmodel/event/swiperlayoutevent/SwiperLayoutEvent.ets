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

import Prompt from '@ohos.promptAction';
import { AttributeUpdater, componentSnapshot, promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { ResUtils } from '@ohos/windowscene';
import {
  AppItemInfo,
  CardItemInfo,
  ClickAddCardEvent,
  CommonConstants,
  FormCommonUtil,
  FormCenterViewManager,
  FormHiSysEventReporter,
  FormModel,
  EventConstants,
  FormManager,
} from '@ohos/launchercommon';
import {
  PageDesktopViewModelProxy,
  IPageDesktopViewModel,
} from '@ohos/launchercommon/Index';
import {
  CheckResult,
  ResultCode,
  ShortcutViewModel,
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';
import {
  GlobalContext,
  HiSysEventUtil,
  localEventManager,
  ResourceManager,
  IconResourceManager,
} from '@ohos/frameworkwrapper';
import { SwiperLayoutEventInterface } from '../../../interfaces/SwiperLayoutEventInterface';
import { FormCenterViewModel, CloseReason } from '../../FormCenterViewModel';
import { FormManageResponse } from '../../../../default/service/ServiceInterface';
import { FormStyleConfig } from '../../../../default/common/FormStyleConfig';
import { FormHiSysEventUtil } from '../../../../default/util/FormHiSysEventUtil';
import { FormCenterViewData } from '../../../../default/viewmodel/FormCenterViewData';
import FormConstants from '../../../../default/common/constants/FormConstants';
import { SwiperLayoutViewData } from '../../data/SwiperLayoutViewData';
import { FormItemEventInterface } from '../../../interfaces/FormItemEventInterface';
import { SwiperFormAnimate } from './SwiperAnimateViewModel';
import { NavDestinationViewData } from '../../../../default/viewmodel/FormCenterObservedData';
import { FormDescriptionEventInterface } from '../../../interfaces/FormDescriptionEventInterface';
import { FormDescriptionVm } from '../../data/FormDescriptionVm';
import { SwiperLayoutFormEvent } from '../FormItemEvent/SwiperLayoutFormEvent';
import { FormCenterFormCommonUtil } from '../FormCenterFormCommonUtil';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';

const TAG = 'SwiperLayoutEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SwiperLayoutEvent implements SwiperLayoutEventInterface {
  protected mAppInfo: AppItemInfo = new AppItemInfo();
  protected parentAnimateModifierList: AttributeUpdater<CommonAttribute>[] = [];
  protected formModifierList: AttributeUpdater<CommonAttribute>[] = [];
  protected swiperLayoutViewData: SwiperLayoutViewData = new SwiperLayoutViewData();
  protected mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
  protected swiperFormAnimate: SwiperFormAnimate = new SwiperFormAnimate();
  protected isSnapshotDone: boolean = false;
  protected swiperAccessibilityTextList: string[] = [];
  protected swiperIndexChangeCallBack?: (formItem: CardItemInfo) => void;
  // 无障碍不支持@state动态更新的场景，需要用AttributeUpdater
  private swiperAttributeUpdater: AttributeUpdater<CommonAttribute> = new AttributeUpdater();

  constructor(swiperLayoutViewData: SwiperLayoutViewData,
    mViewData: NavDestinationViewData,
    appInfo: AppItemInfo,
  ) {
    this.swiperLayoutViewData = swiperLayoutViewData;
    this.swiperFormAnimate.initData(swiperLayoutViewData, mViewData, this.parentAnimateModifierList);
    this.mAppInfo = appInfo;
  }

  onAnimationStart(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent): void {
    this.swiperLayoutViewData.swipeTargetIndex = targetIndex;
    this.swiperFormAnimate.calculateOffSet(targetIndex, extraInfo.velocity);
  }

  onButtonTouch(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this.snapForm();
    }
  }

  onSwiperChange(index: number, oldIndex: number) {
    if (index === oldIndex) {
      return;
    }
    if (index < 0 || index > this.swiperLayoutViewData.appFormList.length) {
      return;
    }
    this.swiperLayoutViewData.swipeTargetIndex = index;

    // 设置是否可拖拽
    this.formModifierList[oldIndex]?.attribute?.draggable(false);
    this.formModifierList[index]?.attribute?.draggable(FormCenterViewModel.getInstance().getIsSupportDrag());
    this.swiperFormAnimate.calculateOffSet(index, 0);
    this.swiperAttributeUpdater.attribute?.accessibilityText(this.swiperAccessibilityTextList[index]);
  }

  onGestureSwipe(index: number, extraInfo: SwiperAnimationEvent) {
    // 滑动打断一镜到底动效
    GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
    this.swiperFormAnimate.updateFormOffset(index, extraInfo.currentOffset);
  };

  onButtonClick(event: ClickEvent) {
    let formItem: CardItemInfo = this.copyCard();
    if (CheckEmptyUtils.isEmpty(formItem.shortcutInfo) && this.checkIsCardExceedLimit()) {
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CREATE_FORM_FAILED);
      FormModel.getInstance().showToastWhenCardExceed();
      return;
    }

    if (!this.isSnapshotDone) {
      log.showWarn(`snap form not done, bundle: ${this.mAppInfo.bundleName}`);
      this.snapForm();
      return;
    }
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM);

    if (!CheckEmptyUtils.isEmpty(formItem.shortcutInfo)) {
      this.addShortcutToDesktop();
    } else {
      this.addFormToDeskTop();
    }
  }

  onAppear() {
    this.indexChangeCallBack(this.swiperLayoutViewData.swipeTargetIndex);
    GlobalContext.getContext()?.eventHub.on('enterFormManagerDone', () => {
      this.parentAnimateModifierList[this.swiperLayoutViewData.swipeTargetIndex]?.attribute?.opacity(1);
    })
  }

  onDisAppear() {
    this.swiperLayoutViewData.formIdMap.clear();
    AppStorage.setOrCreate<boolean>('enterFormManager', false);
    GlobalContext.getContext()?.eventHub.off('enterFormManagerDone');
  };

  public setCardId(index: number, cardId: string) {
    this.swiperLayoutViewData.formIdMap.set(index, cardId);
  }

  getFormItemEvent(index: number): FormItemEventInterface {
    let event: FormItemEventInterface = new SwiperLayoutFormEvent(
      this.swiperLayoutViewData.appFormList[index], index, this.mAppInfo,
      (index: number) => {
        return index === this.swiperLayoutViewData.swipeTargetIndex
      },
      (index: number, cardId: string) => {
        this.setCardId(index, cardId);
      },
      this.swiperFormAnimate,
      (index: number, parentUpdater: AttributeUpdater<CommonAttribute>,
        formModifier: AttributeUpdater<CommonAttribute>) => {
        this.parentAnimateModifierList[index] = parentUpdater;
        this.formModifierList[index] = formModifier;
      });
    return event;
  }

  public initSwiperIndexChangeCallBack(callBack: (formItem: CardItemInfo) => void): void {
    this.swiperIndexChangeCallBack = callBack;
  }

  public getDescriptionEvent(index: number): FormDescriptionEventInterface {
    let formItem = this.swiperLayoutViewData.appFormList[index];
    if (CheckEmptyUtils.isEmpty(formItem)) {
      log.showError(`empty formItem! index: ${index}`);
      return { updateFormDescriptionVm: () => {} };
    }

    if (formItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      return {
        updateFormDescriptionVm: (vm: FormDescriptionVm, item: CardItemInfo): void => {
          vm.mDisplayName = item.description as string;
        }
      };
    }

    return {
      updateFormDescriptionVm: async (vm: FormDescriptionVm, item: CardItemInfo): Promise<void> => {
        // 应用内传入的模板卡片名称，卡片描述
        if (item.targetFormData) {
          vm.mDescription = item.targetDescription ?? '';
          vm.mDisplayName = item.targetLabel ?? '';
          return;
        }
        if (formItem.shortcutInfo !== undefined && !CheckEmptyUtils.isEmpty(formItem.shortcutInfo)) {
          vm.mDisplayName = await IconResourceManager.getInstance().getAppName(
            formItem.shortcutInfo.labelId,
            formItem.shortcutInfo.bundleName,
            formItem.shortcutInfo.moduleName,
            ''
          );
          vm.mDescription = item.bundleName === CommonConstants.SCENEBOARD_BUNDLE ?
            ResUtils.getInnerString($r('app.string.onekeylock_shortcut')) : vm.mDisplayName;
          return;
        }
        vm.mDescription = await FormCenterFormCommonUtil.getResourceName(this.mAppInfo.applicationName ?? '',
          formItem.descriptionId, 'description', formItem);
        vm.mDisplayName = await FormCenterFormCommonUtil.getResourceName(this.mAppInfo.applicationName ?? '',
          formItem.displayNameId, 'displayName', formItem);
      }
    };
  }

  public indexChangeCallBack(index: number): void {
    let formItem: CardItemInfo = this.swiperLayoutViewData.appFormList[index];
    if (!CheckEmptyUtils.isEmpty(formItem)) {
      this.swiperIndexChangeCallBack?.(formItem);
    }
  }

  protected snapForm(): void {
    this.isSnapshotDone = false;
    let bundleName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
      FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.swiperLayoutViewData.appFormList[0]?.bundleName;
    const snapShotId: string =
      FormCenterFormCommonUtil.getFormItemId(bundleName, this.swiperLayoutViewData.swipeTargetIndex);
    let cardId: string = this.swiperLayoutViewData.formIdMap.get(this.swiperLayoutViewData.swipeTargetIndex) ?? '';
    let formItem: CardItemInfo = this.copyCard();
    const cacheKey: string = CheckEmptyUtils.isEmpty(formItem.shortcutInfo) ? `${cardId}${this.mAppInfo?.bundleName}` : `shortcut_${formItem.bundleName}_${formItem.shortcutInfo?.id}`;
    componentSnapshot.get(snapShotId).then((value: image.PixelMap) => {
      log.showInfo(`set ${snapShotId} cardSnapshot cacheKey: ${cacheKey}`);
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'cardSnapshot', value);
      this.isSnapshotDone = true;
    });
  }

  private addShortcutToDesktop(): void {
    let formItem: CardItemInfo = this.copyCard();
    let isAreaEnough: boolean = PageDesktopViewModelProxy.getInstance().hasEnoughArea(formItem);
    if (!isAreaEnough) {
      this.mFormCenterViewManager.closeFormCenterView();
      this.mFormCenterViewManager.closeFormManagerView();
      return;
    }

    let checkResult: CheckResult = ShortcutViewModel.getInstance().checkShortcut(formItem.shortcutInfo);
    log.showWarn(`checkResult ${checkResult?.code}`);
    if (checkResult.code === ResultCode.FAILED_DUPLICATE_ID) {
      Prompt.showToast({
        message: $r('app.string.add_exist_shortcut'),
        showMode: 2
      });
      return;
    }

    let position: Position = FormCenterViewData.getInstance().getAppFormsCenterPosition();
    GlobalContext.getContext().eventHub.emit(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM, formItem,
      [position.x, position.y], 0, `shortcut_${formItem.bundleName}_${formItem.shortcutInfo?.id}`);
    this.createCardAndReport(formItem, (result: boolean) => {
      GlobalContext.getContext()?.eventHub.emit(
        FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT, formItem, result);
    });
    this.mFormCenterViewManager.closeFormCenterView();
    this.mFormCenterViewManager.closeFormManagerView();
  }

  protected addFormToDeskTop(): void {
    log.showWarn('form add to desktop click');
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_ADD_CARD_CLICK);
    let formItem: CardItemInfo = this.copyCard();
    if (!this.checkIsCardValid(formItem.cardId)){
      return;
    }
    HiSysEventUtil.reportEventById('AddFormToDesktop', 'add form to desktop.');
    let isAreaEnough: boolean = PageDesktopViewModelProxy.getInstance().hasEnoughArea(formItem);
    if (!isAreaEnough) {
      // 桌面没有空位，删除已加到卡片框架侧的卡片
      if (formItem.cardId) {
        FormManager.getInstance().deleteCard(formItem.cardId);
      }
      this.mFormCenterViewManager.closeFormCenterView();
      this.mFormCenterViewManager.closeFormManagerView();
      return;
    }
    if (!FormModel.getInstance().isSupportCreateFormAnimate() ||
      !FormCenterViewModel.getInstance().getIsSupportCreateAnimate()) {
      this.createCardAndReport(formItem, (result: boolean) => {
        if (result) {
          promptAction.showToast({
            message: ResourceManager.getInstance().getStringByName('form_added'),
            showMode: 2
          });
        }
      });
    } else {
      let position: Position = FormCenterViewData.getInstance().getAppFormsCenterPosition();
      GlobalContext.getContext().eventHub.emit(FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM, formItem,
        [position.x, position.y], 0, `${formItem.cardId}${formItem.bundleName}`);
      this.createCardAndReport(formItem, (result: boolean) => {
        GlobalContext.getContext()?.eventHub.emit(
          FormConstants.EVENTHUB_FORM_MANAGER_CREATE_FORM_RESULT, formItem, result);
      });
    }
    this.mFormCenterViewManager.closeFormCenterView();
    this.mFormCenterViewManager.closeFormManagerView();
    this.mFormCenterViewManager.closeThemeDetailView();
  }

  protected createCardAndReport(formItem: CardItemInfo,
    createCardCallback: (state: boolean) => void): void {
    let selectType: number | undefined;
    log.showInfo('createCardAndReport');
    PageDesktopViewModelProxy.getInstance().createCardToDeskTop(formItem, () => {
      if (PageDesktopViewModelProxy.getInstance().getCreateCardState()) {
        createCardCallback(true);
        this.reportClickAddCardEvent(formItem, selectType);
      } else {
        createCardCallback(false);
      }
    }, (position: number[], page?: number, screenSelectType?: number) => {
      formItem.row = position[0];
      formItem.column = position[1];
      formItem.page = page;
      selectType = screenSelectType;
    });
  }

  protected reportClickAddCardEvent(item: CardItemInfo, selectType?: number): void {
    if (selectType == undefined || item.cardDimension === undefined ||
      item.area === undefined || item.area.length === 0) {
      log.showWarn(`report click add card UE event failed, please check params, ` +
        `dimension=${item.cardDimension} area=${item.area?.length}.`);
      return;
    }
    if (item.page === undefined || item.column === undefined || item.row === undefined) {
      log.showWarn(`report click add card UE event failed, please check params, ` +
        `page=${item.page} column=${item.column} row=${item.row}.`);
      return;
    }
    let cardDimension: number = item.cardDimension;
    let dpSize = FormStyleConfig.getInstance().mFormWidth.get(cardDimension.toString()) + '*' +
      FormStyleConfig.getInstance().mFormHeight.get(cardDimension.toString());
    let addFormViewSource: number = FormCenterViewManager.getInstance().getOpenAddFormViewSource();
    // 加桌完成将加桌页拉起方式恢复默认值
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(0);
    let addCardEvent: ClickAddCardEvent = {
      packageName: item.bundleName,
      area: item.area,
      dpSize: dpSize,
      formId: item.cardId,
      moduleName: item.moduleName,
      formName: item.cardName,
      page: item.page,
      addType: FormHiSysEventUtil.getClickAddCardType(addFormViewSource),
      column: item.column,
      row: item.row,
      screenType: selectType,
      formType: FormCommonUtil.getFormType(item.gameCardInfo),
    };
    FormHiSysEventReporter.reportAddCardToScreenByClick(addCardEvent);
  }

  protected copyCard(): CardItemInfo {
    let formItem: CardItemInfo = this.swiperLayoutViewData.appFormList[this.swiperLayoutViewData.swipeTargetIndex];
    let copyItem: CardItemInfo = ObjectCopyUtil.deepClone(formItem);
    copyItem.appName = this.mAppInfo?.applicationName;
    copyItem.cardId = this.swiperLayoutViewData.formIdMap.get(this.swiperLayoutViewData.swipeTargetIndex) ?? '';
    copyItem.id = String(copyItem.cardId);
    copyItem.dimension = copyItem.cardDimension;
    copyItem.name = copyItem.cardName;
    log.showWarn(`getChooseCard id: ${copyItem.cardId} dimension: ${copyItem.dimension}`);
    return copyItem;
  }

  addCardToNegativeScreen() {
    log.showWarn('addCardToNegativeScreen');
    let formItem: CardItemInfo = this.copyCard();
    if (!this.checkIsCardValid(formItem.cardId)){
      return;
    }
    if (!this.isSnapshotDone) {
      log.showWarn(`snap form not done, bundle: ${this.mAppInfo.bundleName}`);
      this.snapForm();
      return;
    }
    HiSysEventUtil.reportEventById('AddFormToDesktop', 'add form to NegativeScreen');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_INTELLIGENT_ADD_CARD, formItem);
    FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM);
  }

  public getButtonStatusForNegativeScreen(): boolean {
    let formItem: CardItemInfo = this.copyCard();
    return FormCenterViewModel.getInstance().isDisableButtonForNegativeScreen(formItem.dimension, formItem.bundleName);
  }

  protected checkIsCardExceedLimit(): boolean {
    let isExceedLimit: boolean = FormCenterViewModel.getInstance().getIsIsCardExceedLimit();
    return isExceedLimit;
  }

  private checkIsCardValid(cardId: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      log.showError('invalid cardId, do not handling add form');
      promptAction.showToast({
        message: ResourceManager.getInstance().getStringByName('card_load_error'),
        showMode: 2
      });
      return false;
    }
    return true;
  }
}