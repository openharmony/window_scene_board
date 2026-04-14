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
  LogDomain,
  LogHelper,
  CommonUtils,
  AppStorageUtil,
  DataProperty,
  CheckEmptyUtils,
  SingleContext,
} from '@ohos/basicutils';
import { DeviceHelper, localEventManager, GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import {
  DragDataType,
  DragExtraInfo,
  DragItemPosition,
} from '@ohos/componentdrag';
import { ResUtils } from '@ohos/windowscene';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import { DropAnimationScene } from '@ohos/componentanimator';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  CardItemInfo,
  CommonConstants,
  EditModeUtils,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  StyleConstants,
} from '@ohos/launchercommon';
import { NumberConstants } from '@ohos/commonconstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { FormStyleConfig } from '@ohos/form/src/main/ets/default/common/FormStyleConfig';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { FormStackStyleConstants } from '@ohos/formstack/src/main/ets/common/FormStackStyleConstants';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import { PageDesktopViewModel } from './PageDesktopViewModel';

const TAG = 'DesktopFormStackViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class FormStackItemViewData {
  public mFormStackItemWidth: number = 0;
  public mFormStackItemHeight: number = 0;
  public mFormBorderRadius: number =
    ResourceManager.getInstance().getNumberByResource($r('app.float.form_corner_radius'));
  public mOpacity: number = 1;
}

export class FormStackItemCommonData {
  public mFormStackNameHeight: number = 0;
  public mFormStackNameWidth: number = 0;
  public mFormStackNameSize: number = 0;
  public mSizeRatio: number = 0;
  public mNameFontColor: string = '';
  public mIconNameMargin: number = 0;
  public mIconNameMarginTop: number = 0;
}

export class DesktopFormStackViewModel {
  private singleContext?: SingleContext;
  public mViewDate: FormStackItemViewData = new FormStackItemViewData();
  private readonly mDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private onFormStackItemAccessibilityClickEvent: Function = (): void => this.formStackItemAccessibilityClickEvent();

  constructor(ctx?: SingleContext) {
    this.singleContext = ctx;
  }

  public initData(viewData: FormStackItemViewData): void {
    this.mViewDate = viewData;
  }

  public resetData(): void {
    this.mViewDate = {} as FormStackItemViewData;
  }

  public initViewData(cardDimension: number, isOuterDesktop: boolean = false): void {
    const formStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    if (isOuterDesktop) {
      this.mViewDate.mFormStackItemWidth = Number(formStyleConfig.mOuterFormWidth.get(String(cardDimension)));
      this.mViewDate.mFormStackItemHeight = Number(formStyleConfig.mOuterFormHeight.get(String(cardDimension)));
    } else {
      this.mViewDate.mFormStackItemWidth = Number(formStyleConfig.mFormWidth.get(String(cardDimension)));
      this.mViewDate.mFormStackItemHeight = Number(formStyleConfig.mFormHeight.get(String(cardDimension)));
    }
    let tempRadius = formStyleConfig.getFormBorderRadius(Number(cardDimension));
    if (tempRadius !== CommonConstants.INVALID_VALUE) {
      this.mViewDate.mFormBorderRadius = tempRadius;
    }
    log.showInfo(`init view data, cardDimension: ${cardDimension}, radius: ${tempRadius}, ` +
     `width: ${this.mViewDate.mFormStackItemWidth}, height: ${this.mViewDate.mFormStackItemHeight}.`);
  }

  public iniCommonConfigData(commonData: FormStackItemCommonData): void {
    const styleConfig = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    commonData.mFormStackNameHeight = styleConfig.mNameHeight;
    commonData.mFormStackNameWidth = styleConfig.mNameWidth;
    commonData.mFormStackNameSize = styleConfig.mNameSize;
    commonData.mNameFontColor = styleConfig.mNameFontColor;
    commonData.mIconNameMargin = styleConfig.mIconNameMargin;
    commonData.mIconNameMarginTop = styleConfig.mIconNameMarginTop;

    const itemWidth: number = this.mViewDate.mFormStackItemWidth;
    if (itemWidth > StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) {
      commonData.mSizeRatio = (itemWidth - StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / itemWidth;
    }
  }

  public onPortraitStatusChange(cardDimension: number): void {
    const formStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    this.mViewDate.mFormStackItemWidth = Number(formStyleConfig.mFormWidth.get(String(cardDimension)));
    this.mViewDate.mFormStackItemHeight = Number(formStyleConfig.mFormHeight.get(String(cardDimension)));
    log.showInfo(`onPortraitStatusChange itemWidth: ${this.mViewDate.mFormStackItemWidth}, ` +
      `itemHeight: ${this.mViewDate.mFormStackItemHeight}.`);
  }

  public dragStart(formStackItem: FormStackItemInfo, event: DragEvent): DragItemInfo {
    localEventManager.sendLocalEventSticky(
      EventConstants.EVENT_DESKTOP_MENU_EVENT, NumberConstants.CONSTANT_NUMBER_ONE);
    AppStorageUtil.setOrCreate('isDrag', true, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('selectItem', '', new DataProperty(false, false));
    AppStorageUtil.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_DESKTOP, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('dragItemInfo', formStackItem, new DataProperty(true, false, 'FormStackItemInfo'));

    const x: number = event.getWindowX();
    const y: number = event.getWindowY();
    const selectAppIndex: number = this.mDragHandler.getItemIndex(x, y);
    AppStorageUtil.setOrCreate('selectAppIndex', selectAppIndex, new DataProperty(true, false));

    const startPosition: DragItemPosition = this.mDragHandler.getTouchPosition(x, y);
    this.mDragHandler.onDragStart(x, y);
    this.mDragHandler.setStartPosition(startPosition);

    const itemUniqueKey: string = GridLayoutUtil.generateUniqueKey(formStackItem as Object as GridLayoutItemInfo);
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP,
      GridLayoutUtil.generateUniqueKey(formStackItem as Object as GridLayoutItemInfo))
      ?.setWidth(EditModeUtils.convertWithDesktopScale(this.mViewDate.mFormStackItemWidth))
      .setHeight(EditModeUtils.convertWithDesktopScale(
        this.mViewDate.mFormStackItemHeight + FormStackStyleConstants.BOTTOM_CARD_OFFSET))
      .setOffset(0, EditModeUtils.convertWithDesktopScale(-FormStackStyleConstants.BOTTOM_CARD_OFFSET / 2))
      .setStartOffset(0, EditModeUtils.convertWithDesktopScale(FormStackStyleConstants.BOTTOM_CARD_OFFSET / 2))
      .setImageFit(editModeManager.isInEditMode() ? ImageFit.Contain : ImageFit.Cover);
    log.showInfo(`onDragStart position: [${x}, ${y}], selectAppIndex: ${selectAppIndex}.`);
    const dragImage = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, itemUniqueKey);
    const realScale: number = EditModeUtils.getDesktopScale();
    if (realScale !== 1) {
      // 跟手图尺寸不为1时需要缩放
      dragImage?.scaleSync(realScale, realScale);
    }
    return {
      extraInfo: new DragExtraInfo(DragDataType.FORM_STACK).toString(),
      pixelMap: dragImage
    };
  }

  // 消费onClick事件，避免编辑模式下，onClick事件透传到PageDesktopLayout中导致退出编辑模式
  public onClick(): void {
    log.showInfo('FormStackItem onclick.');
    if (editModeManager.isInEditMode()) {
      return;
    }
  }

  public getStackAccText(formStackItem: FormStackItemInfo): string {
    if (!formStackItem || CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo) ||
    CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo[0])) {
      log.showError('get stack request focus text fail, params is invalid.');
      return '';
    }
    let len: number = formStackItem.layoutInfo[0].length;
    return ResUtils.getInnerPluralByResource($r('app.plural.stack_request_focus_front_text'), len);
  }

  public getStackAccDescription(stackTopName: string): string {
    try {
      if (CheckEmptyUtils.checkStrIsEmpty(stackTopName)) {
        log.showError('get stack request focus text fail, params is invalid.');
        return '';
      }
      return ResUtils.getInnerStringNumS($r('app.string.stack_request_focus_after_text'), `${stackTopName}`);
    } catch (e) {
      return '';
    }
  }

  public initEventhubEvent(formStackId: string | undefined): void {
    // 无障碍模式点击
    let formStackItemAccessibilityClickEventId: string = `formStackItemAccessibilityClick${formStackId}`;
    this.desktopContext?.eventHub.off(formStackItemAccessibilityClickEventId);
    this.desktopContext?.eventHub.on(
      formStackItemAccessibilityClickEventId, this.onFormStackItemAccessibilityClickEvent);
    log.showInfo(`DesktopAccessibility onFormStackItemAccessibilityClickEvent register for formStackItem ${formStackItemAccessibilityClickEventId}`);
  }

  public deInitEventhubEvent(formStackId: string | undefined): void {
    let formStackItemAccessibilityClickEventId: string = `formStackItemAccessibilityClick${formStackId}`;
    this.desktopContext?.eventHub.off(
      formStackItemAccessibilityClickEventId, this.onFormStackItemAccessibilityClickEvent);
    log.showInfo(`DesktopAccessibility onFormStackItemAccessibilityClickEvent unRegister for formStackItem ${formStackItemAccessibilityClickEventId}`);
  }

  public checkCardDimension(cards: CardItemInfo[], area: number[]): void {
    if (CheckEmptyUtils.isEmptyArr(cards) || CheckEmptyUtils.isEmptyArr(area)) {
      log.showError('formstack cards or area empty!');
      return;
    }

    cards.forEach((item) => {
      if (!FormStackUtil.isValidCardType(item.cardDimension)) {
        log.showWarn(`fix card cardDimension, id: ${item.cardId}`);
        item.cardDimension = CardItemInfo.getCardDimension(area);
      }
    });
  }

  private formStackItemAccessibilityClickEvent(): void {
    log.showInfo(`DesktopAccessibility formStackItemAccessibilityClickEvent.`);
    this.onClick();
  }
}