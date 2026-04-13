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

import { image } from '@kit.ImageKit';
import { ImageModifier } from '@ohos.arkui.modifier';
import { LengthMetrics, performanceMonitor } from '@kit.ArkUI';
import {
  FormCenterViewManager,
  FormCenterViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { SnapshotType, ObjectCopyUtil, dragSnapshotHelper } from '@ohos/componenthelper';
import { GlobalContext, HiSysEventUtil, localEventManager, ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  CommonConstants,
  CardItemInfo,
  FormManager,
  vibratorMgr,
  FormModel,
  FormCommonUtil,
  EditModeUtils,
  FormLocation,
  StyleConstants,
  DesktopUtils,
  GridLayoutItemInfo,
  FormLayoutCacheManager,
  EventConstants,
} from '@ohos/launchercommon';
import { FormStyleConfig } from '../../common/FormStyleConfig';
import { FormItemBuilderInterface } from '../../common/FormItemBuilderInterface';
import DesktopForm from '../DesktopForm';
import { FormManageResponse } from '../../service/ServiceInterface';
import lazy PcFormStyleConstants from '../../common/constants/PcFormStyleConstants';
import { RecommendFormsViewEvent } from '../../viewmodel/RecommendFormsViewEvent';
import StyleManager from '../../manager/StyleManager';
import { FormCenterViewModel, CloseReason } from '../../../formcenter/viewmodel/FormCenterViewModel';
import FormStyleConstants from '../../common/constants/FormStyleConstants';
import { SearchStateMgr } from '../../../formcenter/view/atomicview/SearchComponent';
import { SingleAppResult } from '../../../formcenter/util/FusionSearchUtil';

const TAG = 'GridStyleFormItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DRAG_CARD_END_INTERVAL: number = 500;
const DEFAULT_CARD_ID: string = '0';

@Component
export struct GridStyleFormItem {
  private formSnapId: string = '';
  private mEvent: RecommendFormsViewEvent | undefined = undefined;
  private formItem: CardItemInfo = new CardItemInfo();
  private idIndex: number = 0;
  private isDragForm: boolean = false;
  private gridHeight: number = 0;
  private formRate: number = 1;
  private formWidth: number = 0;
  private formHeight: number = 0;
  private radius: number = 0;
  private cardId: string = '';
  private isCardExceedLimit: boolean = false;
  private buildInterface?: FormItemBuilderInterface;
  private appName: string | undefined;
  private extCardID: string = DEFAULT_CARD_ID;
  private isDisappearing: boolean = false;
  private addCard: Callback<void> | undefined = undefined;
  @State needExt: boolean = false;
  @State displayName: string | undefined = undefined;
  @State formDescription: string | undefined = undefined;
  @State dragSnapshot: image.PixelMap | undefined = undefined;
  @State formScale: number = StyleManager.getCommonStyle().defaultScale;
  @State formLongPressHide: boolean = false;
  @State isShowResult: boolean = false;
  @State displayNameSearchResult: string[] = [];
  @StorageLink('fontSizeScale') fontScale: number | undefined = undefined;
  @Prop @Watch('refreshSearchResult') refreshFlag: boolean = false;

  private refreshSearchResult(): void {
    this.isShowResult = SearchStateMgr.getInstance().getIsShowSearchResult();
    if (!this.isShowResult) {
      return;
    }

    let searchResult: SingleAppResult | undefined =
      SearchStateMgr.getInstance().parsedSearchResult.get(this.formItem.bundleName);
    let displayNameMap: Map<string, string> = searchResult?.descriptionMap ?? new Map();
    let displayName: string = displayNameMap.get(this.formItem.cardName) ?? '';
    this.displayNameSearchResult = this.getHighLightArr(displayName);
    log.showDebug(`refreshSearchResult: ${this.displayNameSearchResult}`);
  }

  private getHighLightArr(highlightStr: string): string[] {
    if (CheckEmptyUtils.checkStrIsEmpty(highlightStr)) {
      log.showWarn('highlight string is empty!');
      return [];
    }

    return highlightStr.split(/(<em>|<\/em>)/i);
  }

  aboutToAppear(): void {
    this.buildInterface = new DesktopForm();
    this.appName = FormCenterViewModel.getInstance().getAppInfo(this.formItem.bundleName)?.applicationName;
    let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
    this.radius = formStyleConfig.getRadius(false, this.formItem.cardDimension);
    if (this.formItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE) {
      this.formDescription = this.formItem.description;
    } else {
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      resourceManager.getAppNameSync(this.formItem.descriptionId, this.formItem.bundleName,
        this.formItem.moduleName, this.formItem.appName).then((value: string) => {
        log.showWarn(`get form description: ${value}`);
        this.formDescription = value;
      });
    }
    this.updateFormDescription(this.formItem);
    this.initFormSnapId();
    this.refreshSearchResult();
    log.showDebug('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showDebug(`aboutToDisappear, ${this.idIndex}`);
    if (!this.isDragForm) {
      ResourceManager.getInstance().deleteAppResourceCache(`${this.cardId}${this.formItem.bundleName}`, 'cardSnapshot');
      FormManager.getInstance().deleteCard(this.cardId.toString());
    }
    if (this.extCardID !== DEFAULT_CARD_ID) {
      FormManager.getInstance().deleteCard(this.extCardID);
    }
  }

  private initFormSnapId(): void {
    let appListItemName: string = FormCenterViewModel.getInstance().isCurrentSuggestion ?
      FormStyleConstants.FORM_CENTER_DEFAULT_ITEM : this.formItem.bundleName;
    this.formSnapId = `${TAG}_Stack_${appListItemName}_${this.idIndex}`;
  }

  private updateFormDescription(formItem: CardItemInfo): void {
    let resourceManager: ResourceManager = ResourceManager.getInstance();
    resourceManager.getAppNameSync(formItem.descriptionId, formItem.bundleName,
      formItem.moduleName, this.appName).then((value: string) => {
      log.showWarn(`get form description: ${value}`);
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        this.formDescription = this.appName;
        return;
      }
      this.formDescription = value;
    });
    resourceManager.getAppNameSync(formItem.displayNameId, formItem.bundleName,
      formItem.moduleName, this.appName).then((value: string) => {
      log.showWarn(`get form displayName: ${value}`);
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        this.displayName = this.appName;
        return;
      }
      this.displayName = value;
    });
  }

  private getFormWant(): Want | undefined {
    if (FormCenterViewModel.getInstance().isScreenLock) {
      return undefined;
    }
    return FormCommonUtil.getCommonWant({
      isTransparent: this.formItem.isTransparent,
      formLocation: FormLocation.FORM_CENTER
    });
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction((event: GestureEvent) => {
            this.mEvent?.longPressHandler(this.idIndex);
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent) => {
            if (this.isCardExceedLimit) {
              FormModel.getInstance().showToastWhenCardExceed();
            }
            if (event?.source === SourceType.Mouse) {
              // 鼠标长按不响应震动
              log.showWarn('not response for mouse action');
              return;
            }
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
          })
      )
    )
  }

  @Styles
  dragStyles() {
    .draggable(!this.isCardExceedLimit && FormCenterViewModel.getInstance().getIsSupportDrag())
    .onPreDrag((status: PreDragStatus) => {
      log.showInfo('onPreDrag status change ' + String(status));
      // 浮起预览图时隐藏卡片
      if (status === PreDragStatus.PREVIEW_LIFT_STARTED) {
        this.formLongPressHide = true;
        return;
      }
      // 预览图消失时恢复显示卡片
      if (status === PreDragStatus.PREVIEW_LANDING_FINISHED) {
        this.formLongPressHide = false;
        return;
      }
    })
    .onDragStart((event: DragEvent, extraParams?: string) => {
      // 如果从大文件夹打开，需要关闭大文件夹
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.FOLDER_STATUS_REQUEST_CLOSE);
      this.isDragForm = true;
      FormCenterViewModel.getInstance().setCloseReason(CloseReason.CLOSE_BY_ADD_FORM);
      performanceMonitor.begin(HiSysEventUtil.FORM_MANAGER_CREATE_FORM, performanceMonitor.ActionType.LAST_DOWN);
      return this.mEvent?.onDragStart(this.cardId, this.formItem,
        this.mEvent?.getDragStartPositionOffset(this.formSnapId, event),
        this.dragSnapshot, ImageFit.Fill);
    })
    .onDragEnd((event: DragEvent) => {
      this.mEvent?.onDragEnd(false);
      setTimeout(() => {
        // 创建成功后，再次拉起
        log.showWarn('openFormCenterView');
        let param: FormCenterViewParam = new FormCenterViewParam();
        param.bundleName = this.formItem.bundleName;
        param.formInfo = this.formItem;
        FormCenterViewManager.getInstance().openFormCenterView(param);
      }, DRAG_CARD_END_INTERVAL);
    })
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier().borderRadius(this.radius * this.formRate)
    })
    .dragPreview({
      pixelMap: this.dragSnapshot
    })
  }

  @Builder
  formItemBuilder() {
    Stack() {
      if (this.needExt) {
        this.buildInterface?.buildView()?.builder({
          formUIConfig: {
            formItem: this.formItem,
            formScale: this.formRate,
            cardId: this.extCardID,
            index: this.idIndex,
            formWidth: this.formWidth,
            formHeight: this.formHeight,
            formOpacity: 0,
            formRadius: this.radius,
            want: this.getFormWant(),
          },
          event: {
            onAcquired: (cardId: string) => {
              this.extCardID = cardId;
              log.showInfo(`onAcquired:${this.extCardID}`);
              this.addCard?.();
            },
            onLoad: () => {
            },
            onDisappear: () => {
              this.isDisappearing = false;
            }
          }
        })
      }

      this.buildInterface?.buildView()?.builder({
        formUIConfig: {
          formItem: this.formItem,
          formScale: this.formRate,
          cardId: this.cardId,
          index: this.idIndex,
          formWidth: this.formWidth,
          formHeight: this.formHeight,
          formRadius: this.radius,
          want: this.getFormWant(),
        },
        event: {
          onAcquired: (cardId: string) => {
            this.cardId = cardId;
          },
          onLoad: () => {
          }
        }
      })
    }
    .focusBox({ margin:LengthMetrics.vp(0), strokeWidth: LengthMetrics.vp(2) })
    .onHover((isHover: boolean) => {
      this.formScale =
        isHover ? StyleManager.getSheetFormStyle().cardMagnifyScale : StyleManager.getCommonStyle().defaultScale;
    })
    .scale({
      x: this.formScale,
      y: this.formScale
    })
    .opacity(this.formLongPressHide ? 0.005 : 1)
    .attributeModifier(this.buildInterface?.applyFormManagerAttribute?.(Color.Transparent, false,
      {
        width: Math.floor(vp2px(this.formWidth * this.formRate)) + 'px',
        height: Math.floor(vp2px(this.formHeight * this.formRate)) + 'px'
      }, this.radius * this.formRate, false))
    .id(this.formSnapId)
    .onClick(() => {
      if (this.extCardID !== DEFAULT_CARD_ID) {
        this.onClickEvent();
      } else {
        this.addCard = () => this.onClickEvent();
      }
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down && !this.isDisappearing) {
        this.needExt = true;
      }
    })
    .dragStyles()
  }

  private onClickEvent(): void {
    if (this.isCardExceedLimit) {
      GlobalContext.getContext()?.eventHub.emit('waitFormManagerResponse', FormManageResponse.CREATE_FORM_FAILED);
      FormModel.getInstance().showToastWhenCardExceed();
      return;
    }
    let formItem: CardItemInfo = new CardItemInfo();
    ObjectCopyUtil.deepClone<CardItemInfo>(this.formItem, formItem);
    formItem.appName = this.appName;
    formItem.cardId = this.extCardID;
    formItem.id = this.extCardID;
    formItem.dimension = this.formItem.cardDimension;
    formItem.name = formItem.cardName;
    if (this.extCardID === DEFAULT_CARD_ID || FormLayoutCacheManager.getInstance().selectAllFormsList()
      .some((item: GridLayoutItemInfo) =>
      DesktopUtils.getItemKey(formItem as object as GridLayoutItemInfo) === DesktopUtils.getItemKey(item))) {
      return;
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD, formItem);
    this.needExt = false;
    this.addCard = undefined;
    this.isDisappearing = true;
    this.extCardID = DEFAULT_CARD_ID;
  }

  getTextTopPadding(): number {
    let topPadding: number = PcFormStyleConstants.PC_GRID_ITEM_TEXT_TOP_PADDING;
    if (this.fontScale && this.fontScale >= StyleConstants.FONT_MAX_SCALE_FORM_TEXT) {
       topPadding = StyleManager.getSheetFormStyle().fontMaxScalePadding;
    }
    return topPadding;
  }

  @Builder
  formBuilder() {
    Column() {
      this.formItemBuilder()
    }
    .backgroundColor(this.formItem.isTransparent ? $r('app.color.transparent_form_background_color') : Color.Transparent)
    .attributeModifier(this.buildInterface?.applyFormCenterAttribute?.())
    .borderRadius(this.radius * this.formRate)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down && !this.dragSnapshot) {
        dragSnapshotHelper.snapshotFromId(this.formSnapId, SnapshotType.DROP,
          `${this.formItem.typeId}${this.cardId}`,
          (value: image.PixelMap) => {
            this.dragSnapshot = value;
            const cacheKey: string = `${this.cardId}${this.formItem.bundleName}${this.formItem.moduleName}`;
            ResourceManager.getInstance().setAppResourceCache(cacheKey, 'cardSnapshot', value);
          }, undefined, undefined, `GridStyleFormItem_onTouch`);
      }
      this.mEvent?.onTouch(event, this.idIndex);
    })
    .longPressGestureStyles()
  }

  build() {
    Column() {
      Column() {
        this.formBuilder()
      }
      .width(this.formWidth * this.formRate)
      .height(this.gridHeight)
      .justifyContent(FlexAlign.Center)

      Column() {
        Text(this.displayName) {
          if (this.isShowResult) {
            ForEach(this.displayNameSearchResult, (str: string, index: number) => {
              if (str !== '<em>' && str !== '</em>') {
                Span(str).fontColor(this.displayNameSearchResult[index - 1] === '<em>' ?
                  $r('sys.color.font_emphasize') : undefined)
              }
            })
          }
        }
          .draggable(false)
          .id(`${TAG}_${this.idIndex}_Text_appName`)
          .font({
            family: 'HarmonyHeiTi',
            size: PcFormStyleConstants.PC_GRID_ITEM_TEXT_APP_NAME_SIZE,
            weight: FontWeight.Medium
          })
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .maxLines(1)
          .height(ResUtils.getNumber($r('app.float.form_name_height')))
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            bottom: LengthMetrics.vp(ResUtils.getNumber($r('app.float.form_name_gap')))
          })
        Text(this.formDescription)
          .draggable(false)
          .font({
            family: 'HarmonyHeiTi',
            size: PcFormStyleConstants.PC_GRID_ITEM_TEXT_DESCRIPTION_SIZE,
            weight: FontWeight.Regular
          })
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .maxLines(1)
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .id(`${TAG}_${this.idIndex}_Text_${this.formDescription}`)
      }
      .padding({
        top: LengthMetrics.vp(this.getTextTopPadding())
      })
      .height(PcFormStyleConstants.PC_GRID_COLUMN_GAP)
    }
    .alignItems(HorizontalAlign.Center)
    .onDisAppear(() => {
      log.showWarn('onDisAppear');
    })
  }
}