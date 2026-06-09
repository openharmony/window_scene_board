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

import { CardItemInfo, FormModel, StyleConstants, CommonConstants, FormCommonUtil } from '@ohos/launchercommon';
import {
  LogHelper,
  LogDomain,
  DomainName,
  TaskpoolUtil,
  CheckEmptyUtils,
  TraceUtil,
  SingleContext
} from '@ohos/basicutils';
import { FormLocation } from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import FormStyleConstants from '../constants/FormStyleConstants';
import { FormStyleConfig } from '../FormStyleConfig';
import { FormViewModel } from '../../viewmodel/FormViewModel';
import { FormUtil } from '../../util/FormUtil';

const TAG = 'FormManagerDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * Form manager view  Component (pad adaptation).
 */
@CustomDialog
export struct FormManagerDialog {
  @StorageLink('showUninstallDialog') @Watch('showUninstallDialogChange') showUninstallDialog: boolean = false;
  @State mAllowUpdate: boolean = true;
  @Prop singleContext?: SingleContext;
  @State isTransparent: boolean = false;
  @State formCardItemArr: LazyDataSource<FormCardItem> = new LazyDataSource<FormCardItem>();
  @State isShowIndicator: boolean = false;
  private mSwiperController: SwiperController = new SwiperController()
  private mFormModel: FormModel = FormModel.getInstance();
  private mSwiperIndex: number = 0;
  private mFormIdList: string[] = [];
  private mFormStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
  private mFormViewModel: FormViewModel = FormViewModel.getInstance(this.singleContext);
  private isCardExceedLimit: boolean = false;
  private isPcEditCard: boolean = false;
  private formItem: CardItemInfo[] = [];

  mFormDialogController?: CustomDialogController;
  cancel?: Function;
  confirm?: Function;
  bundleName: string = '';
  appName: string = '';
  appLabelId: number = 0;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.mFormModel = FormModel.getInstance();
    this.mFormViewModel = FormViewModel.getInstance(this.singleContext);
    this.mFormStyleConfig = this.mFormViewModel.getFormStyleConfig();
    this.cancel?.((): void => this.clearAllFormById());
    this.getCurrentFormInfo();
    this.isCardExceedLimit = this.mFormModel.checkIfCardExceedLimit();
    log.showInfo(`current isCardExceedLimit: ${this.isCardExceedLimit}`);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.mFormIdList.splice(0, this.formItem.length);
    for (let i: number = 0; i < this.formCardItemArr.totalCount(); ++i) {
      this.formCardItemArr.deleteItemByIndex(i);
    }
    this.formItem.splice(0, this.formItem.length);
  }

  /**
   * Get current form information by bundle name.
   */
  private async getCurrentFormInfo(): Promise<void> {
    this.formItem = await this.mFormModel.getFullFormsInfoByBundleName(this.bundleName) ?? [];
    if (this.formItem && this.formItem.length > this.mSwiperIndex) {
      this.isTransparent = this.formItem[this.mSwiperIndex].isTransparent;
    }
    this.formItem.forEach((item: CardItemInfo) => {
      if (this.mFormModel.isFormCenterSupportCard(item)) {
        item.supportDimensions.forEach((dimension: FormDimension) => {
          let formCardItem: FormCardItem = new FormCardItem();
          formCardItem.id = item.cardId;
          formCardItem.name = item.cardName;
          formCardItem.bundleName = item.bundleName;
          formCardItem.abilityName = item.abilityName;
          formCardItem.moduleName = item.moduleName;
          formCardItem.isTransparent = item.isTransparent;
          formCardItem.description = item.description;
          formCardItem.cardDimension = item.cardDimension;
          formCardItem.formConfigAbility = item.formConfigAbility;
          formCardItem.dimension = dimension;
          this.formCardItemArr.pushItem(formCardItem);
          this.mFormIdList.push('');
        });
      }
    });
    if (this.formCardItemArr.totalCount() > 1) {
      this.isShowIndicator = true;
    }
  }

  private addToDesktopButtonClick(): void {
    log.showInfo('add form to desktop button click');
    if (this.isCardExceedLimit) {
      this.mFormModel.showToastWhenCardExceed();
      return;
    }
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_ADD_CARD_CLICK);
    this.mFormDialogController?.close();
    this.confirm?.(this.getChooseCard());
    this.clearNoUseFormById();
    /**
     * After cards are added to the desktop, unused card information is deleted,
     * and temporary cards stored in mFormIdList are also deleted.
     * Otherwise, operations will be performed on invalid card IDs.
     */
    this.mFormIdList.length = 0;
  }

  /**
   * Get choose card info from current form information.
   *
   * @return <any> formCardItem
   */
  private getChooseCard(): FormCardItem {
    let formCardItem: FormCardItem = this.formCardItemArr.getData(this.mSwiperIndex);
    formCardItem.id = this.mFormIdList[this.mSwiperIndex];
    return formCardItem;
  }

  /**
   * Keep the form which be added to the desktop, and delete the remaining forms.
   */
  private async clearNoUseFormById(): Promise<void> {
    TaskpoolUtil.doTask(clearNoUseFormByIdTask, this.mFormIdList, this.mSwiperIndex);
  }

  /**
   * Delete all form by id.
   */
  private clearAllFormById(): void {
    log.showInfo(`clearAllFormById: ${this.mFormIdList.toString()}`);
    TaskpoolUtil.doTask(clearAllFormByIdTask, this.mFormIdList);
  }

  private showUninstallDialogChange() {
    log.showInfo(`showUninstallDialog=${this.showUninstallDialog}`);
    if (!this.showUninstallDialog) {
      this.mFormDialogController?.close();
      this.clearAllFormById();
    }
  }

  build() {
    // double border layout: build the inner border with column container which is the children of stack.
    Stack({ alignContent: Alignment.Center }) {
      // innerBorder container
      Column() {
      }
      .width(FormStyleConstants.FORM_MANAGER_VIEW_WIDTH)
      .height(FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT)
      .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))

      .backgroundEffect({
        policy: 1,
        radius: StyleConstants.DEFAULT_FORM_DIALOG_BLUR_RADIUS,
        saturation: StyleConstants.DEFAULT_FORM_DIALOG_SATURATION,
        brightness: StyleConstants.DEFAULT_FORM_DIALOG_BRIGHTNESS,
        color: StyleConstants.DEFAULT_FORM_DIALOG_BG_COLOR_NEW
      }, { disableSystemAdaptation: true })
      .visibility(this.isPcEditCard ? Visibility.Visible : Visibility.None)

      Column() {
        Text(this.appName).draggable(false)
          .id(`${TAG}_Text_appName`)
          .width('70%')
          .height(StyleConstants.DEFAULT_33)
          .fontSize(FormStyleConstants.DEFAULT_FORM_MGR_TEXT_FONT_SIZE)
          .margin({ top: FormStyleConstants.DEFAULT_FORM_MARGIN, bottom: FormStyleConstants.DEFAULT_FORM_MARGIN })
          .textAlign(TextAlign.Center)
        Swiper(this.mSwiperController) {
          LazyForEach(this.formCardItemArr, (formItem: FormCardItem, formIndex: number) => {
            Column() {
              Text(formItem.description as string)
                .draggable(false)
                .id(`${TAG}_Text_formItemDesc`)
                .width('70%')
                .height(StyleConstants.DEFAULT_19)
                .fontSize(FormStyleConstants.DEFAULT_FORM_DES_TEXT_FONT_SIZE)
                .textAlign(TextAlign.Center)
              Flex({
                direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
                if (this.bundleName == formItem.bundleName) {
                  FormComponent({
                    id: FormCommonUtil.transformCardId(formItem.id),
                    name: formItem.name as string,
                    bundle: formItem.bundleName as string,
                    ability: formItem.abilityName as string,
                    module: formItem.moduleName as string,
                    dimension: formItem.dimension as number,
                    want: FormUtil.getWant(formItem.isTransparent as boolean, FormLocation.FORM_MANAGER),
                  })
                    .hoverEffect(HoverEffect.None)
                    .hitTestBehavior(HitTestMode.None)
                    .size({
                      width: this.mFormStyleConfig.mFormWidth.get(String(formItem.cardDimension as number)) as number,
                      height: this.mFormStyleConfig.mFormHeight.get(String(formItem.cardDimension as number)) as number,
                    })
                    .borderRadius(FormStyleConstants.FORM_DIALOG_RADIUS)
                    .scale({ x: FormStyleConstants.SCALE_PERCENTAGE_PC, y: FormStyleConstants.SCALE_PERCENTAGE_PC })
                    .allowUpdate(this.mAllowUpdate)
                    .visibility(Visibility.Visible)
                    .onAcquired((form: FormCallbackInfo) => {
                      if (CheckEmptyUtils.isEmpty(form)) {
                        log.showError('form manager dialog onAcquired formCallbackInfo invalid!');
                        return;
                      }

                      formItem.id = String(form.idString);
                      log.showInfo('onAcquired form id' + form.idString);
                      this.mFormIdList[formIndex] = String(form.idString);
                      log.showInfo('onAcquired');
                    })
                    .onError((error) => {
                      log.showError(`onError msg: ${error.msg}`);
                    })
                }
              }
              .height(StyleConstants.DEFAULT_FORM_COMPONENT_HEIGHT)
            }
            .width('100%')
          }, (formItem: FormCardItem): string => this.formCardItemArr.indexOf(formItem).toString())
        }
        .indicator(this.isShowIndicator)
        .width('100%')
        .height(StyleConstants.DEFAULT_FORM_FONT_CONTENT_WEIGHT)
        .loop(false)
        .index(this.mSwiperIndex)
        .onChange((index: number) => {
          this.mSwiperIndex = index;
          this.isTransparent = this.formCardItemArr.getData(index).isTransparent as boolean;
          log.showInfo(`onChange index=${index}`);
        })
        .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
          log.showInfo('onAnimationStart current index=%{public}d, targetIndex=%{public}d', index, targetIndex);
          this.mSwiperIndex = (index !== targetIndex) ? targetIndex : index;
          this.isTransparent = this.formCardItemArr.getData(targetIndex).isTransparent as boolean;
        })
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          Button() {
            Text($r('app.string.add_to_desktop')).draggable(false)
              .id(`${TAG}_Text_addToDesktop`)
              .fontSize($r('sys.float.ohos_id_text_size_button1'))
              .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
          }.id(`${TAG}_Button2_addToDesktop`)
          .backgroundColor($r('sys.color.ohos_id_color_activated'))
          .height(StyleConstants.DEFAULT_BUTTON_HEIGHT)
          .width(StyleConstants.DEFAULT_BUTTON_WIDTH_FORM_DIALOG)
          .onClick(() => {
            this.addToDesktopButtonClick();
          })
        }
      }
      .backgroundColor(this.isPcEditCard ? StyleConstants.DEFAULT_FORM_DIALOG_BG_COLOR_TRANSPARENT : $r('sys.color.ohos_id_color_dialog_bg'))
      .padding({
        bottom: StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN
      })
      .width(FormStyleConstants.FORM_MANAGER_VIEW_WIDTH)
      .height(FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT)
      .border({
        radius: $r('sys.float.ohos_id_corner_radius_dialog'),
        color: StyleConstants.PC_DIALOG_INNER_BORDER_COLOR,
        width: this.isPcEditCard ? StyleConstants.PC_DIALOG_BORDER_WIDTH : 0
      })
    }
    .shadow({
      radius: this.isPcEditCard ? StyleConstants.PC_DIALOG_SHADOW_RADIUS : 0,
      color: StyleConstants.PC_DIALOG_SHADOW_COLOR
    })
    .border({
      radius: this.isPcEditCard ? StyleConstants.PC_DIALOG_OUTER_RADIUS : $r('sys.float.ohos_id_corner_radius_dialog'),
      color: StyleConstants.PC_DIALOG_OUTER_BORDER_COLOR,
      width: this.isPcEditCard ? StyleConstants.PC_DIALOG_BORDER_WIDTH : 0
    })
    .margin({ left: $r('sys.float.ohos_id_dialog_margin_start'), right: $r('sys.float.ohos_id_dialog_margin_end') })
  }
}

export class FormCardItem {
  public id?: string;
  public name?: string;
  public bundleName?: string;
  public abilityName?: string;
  public moduleName?: string;
  public dimension?: number;
  public formConfigAbility?: string;
  public appLabelId?: number;
  public isTransparent?: boolean;
  public description?: string;
  public cardDimension?: number;
};

function clearNoUseFormByIdTask(formIdList: string[], swiperIndex: number): void {
  'use concurrent';
  const TAG = 'FormManagerDialog';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
  log.showInfo('clearNoUseFormByIdTask start');
  TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_CLEAR_NO_USR_FORM);
  for (let i = 0; i < formIdList.length; i++) {
    if (i !== swiperIndex && !CheckEmptyUtils.checkStrIsEmpty(formIdList[i])) {
      FormModel.getInstance().deleteFormByFormID(formIdList[i]);
      log.showDebug('deleteFormByFormID:' + formIdList[i]);
    }
  }
}

function clearAllFormByIdTask(formIdList: string[]): void {
  'use concurrent';
  const TAG = 'FormManagerDialog';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
  log.showInfo('clearAllFormByIdTask start');
  formIdList.forEach((value: string) => {
    if (!CheckEmptyUtils.checkStrIsEmpty(value)) {
      FormModel.getInstance().deleteFormByFormID(value);
      log.showDebug('deleteFormByFormID:' + value);
    }
  });
}