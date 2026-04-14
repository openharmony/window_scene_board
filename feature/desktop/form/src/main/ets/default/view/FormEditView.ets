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

import { LengthMetrics } from '@kit.ArkUI';
import {
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  FormEditViewController,
  FormEditViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import {
  AppItemInfo,
  CardItemInfo,
  CommonConstants,
  DeviceState,
  FormCommonUtil,
  FormEditViewManager,
  FormManager,
  FormModel,
  StyleConstants,
  ReceiveEventInfo,
  GridLayoutUtil,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  GlobalContext,
  IconResourceManager,
  ResourceManager,
  localEventManager,
  ViewCallback,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene';
import FormConstants from '../common/constants/FormConstants';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { FormEditViewData, ViewData } from '../viewmodel/FormEditViewData';
import { FormCenterViewModel } from '../viewmodel/FormCenterViewModel';

const TAG = 'FormEditView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const EMPTY_FORM_ID: string = 'emptyFormId';
const EDIT_FORM_VALID_DURATION: number = 500;

@Component
export struct FormEditView {
  private mFormEditViewData: FormEditViewData = FormEditViewData.getInstance();
  private mFormEditViewManager: FormEditViewManager = FormEditViewManager.getInstance();
  private mStartFormInfo: CardItemInfo = new CardItemInfo();
  private mViewController: FormEditViewController = {
    showView: (param: FormEditViewParam): void => {
      this.showView(param);
    },
    closeView: () => {
      this.closeView();
    },
    hideView: () => {
      this.mBindSheetHeight = 0;
    },
    getViewState: () => {
      return this.mEditViewShow;
    },
    backGestureHandler: () => {
      this.closeView();
    }
  };
  private mAppInfo: AppItemInfo = new AppItemInfo();
  private mFormWidth: number = 0;
  private mFormHeight: number = 0;
  private mFormScale: number = 1;
  private detentsDidChange: boolean = false;
  private closeFormEffect: boolean = false;
  private isOuterDesktop: boolean = launcherStatusUtil.getShowOutLauncherStatus();
  mViewStateChangeCallback?: ViewCallback;
  @State previewCardId: string = '';
  @State mViewData: ViewData = new ViewData();
  @State @Watch('onFormEditStateChange') mEditViewShow: boolean = false;
  @State mBindSheetHeight: number = 0;
  @State mFormEditScrollHeight: number = 0;
  @State mAppName: string = '';
  @State mAppIcon: string | PixelMap | Resource = '';
  @State mDisplayName: string = '';
  @StorageProp('lockReceived') @Watch('closeView') lockReceived: number = 0;
  @StorageProp('isPortrait') @Watch('onPortraitChange') mIsPortrait: boolean = true;
  @StorageProp('folderStatus') @Watch('closeView') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageProp('currColorMode') currColorMode: number = 1;
  @State isLoadFinish: boolean = false;

  private showView(param: FormEditViewParam): void {
    this.isOuterDesktop = launcherStatusUtil.getShowOutLauncherStatus();
    if (!this.mEditViewShow) {
      this.destroyViewData();
      let bundleName: string | undefined = param?.bundleName;
      let tmpAppInfo = FormModel.getInstance().getAppInfoByBundleName(bundleName);
      if (!tmpAppInfo) {
        log.showError(`can not get ${bundleName} appInfo`);
        return;
      }
      this.mAppInfo = tmpAppInfo;

      if (param?.formInfo) {
        this.mStartFormInfo = param.formInfo;
      }
      this.setAppDetailInfo();
      this.setDisplayName();
      this.mViewData = this.mFormEditViewData.getViewData(this.mIsPortrait);
      this.mFormEditViewData.setFormAppEditHeight(param.viewHeight);
      this.mBindSheetHeight = this.mViewData.bindSheetHeight;

      const mFormSize: Size = this.mFormEditViewData.getEditFormDisplaySize(this.mStartFormInfo.cardDimension);
      this.mFormWidth = mFormSize.width;
      this.mFormHeight = mFormSize.height;
      this.mFormScale = this.mFormEditViewData.getFormDimensionScale(this.mStartFormInfo.cardDimension);
      log.showWarn(`mFormSize: ${mFormSize.width}_${mFormSize.height}, isOuterDesktop: ${this.isOuterDesktop}`);
      this.mViewStateChangeCallback?.onShow?.(TAG);
      this.mEditViewShow = true;
      return;
    }

    if (this.mBindSheetHeight !== 0) {
      log.showInfo('showView reentrant, do nothing');
      return;
    }

    this.mBindSheetHeight = this.mViewData?.bindSheetHeight;
    log.showInfo(`recovery formEditView current height: ${this.mBindSheetHeight}`);
  }

  private closeView(): void {
    log.showInfo('close form edit view');
    this.mEditViewShow = false;
    // 打断动效
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
  }

  private onPortraitChange(): void {
    log.showInfo('onPortraitChange: ' + String(this.mIsPortrait));
    this.mFormEditViewData.updateViewDate(this.mIsPortrait);
    this.mBindSheetHeight = this.mViewData.bindSheetHeight;
    this.mFormEditScrollHeight = this.getFormEditScrollHeight();
    // 打断动效
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
  }

  private onFormEditStateChange(): void {
    log.showWarn(`onFormEditStateChange: ${this.mEditViewShow}`);
  }

  private setAppDetailInfo(): void {
    let iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    this.mAppName = this.mAppInfo.applicationName as string;
    if (CheckEmptyUtils.checkStrIsEmpty(this.mAppName)) {
      this.mAppName = iconResourceManager.getCachedIconNameSync(this.mAppInfo.bundleName,
        this.mAppInfo.moduleName, this.mAppInfo.abilityName);
      log.showWarn(`update appName ${this.mAppName}`);
    }
    iconResourceManager.getCombIcon(this.mAppInfo.bundleName,
      this.mAppInfo.moduleName, this.mAppInfo.abilityName).then((icon: string | PixelMap | Resource) => {
      this.mAppIcon = icon;
      log.showWarn(`update appIcon is invalid? ${!icon}`);
    });
  }

  private setDisplayName(): void {
    // 查找卡片信息
    let formList: CardItemInfo[] = FormModel.getInstance().getAppItemTotalFormInfo(this.mAppInfo.bundleName) ?? [];
    if (formList.length > 0) {
      let index: number = FormCenterViewModel.getInstance().getAppFormsIndex(this.mStartFormInfo, formList);
      this.mStartFormInfo.displayNameId = formList[index]?.displayNameId ?? 0;
    }
    log.showWarn(`displayNameId is: ${this.mStartFormInfo.displayNameId}`);

    ResourceManager.getInstance().getAppNameSync(this.mStartFormInfo.displayNameId, this.mStartFormInfo.bundleName
      , this.mStartFormInfo.moduleName, this.mStartFormInfo.cardName ?? '').then((value: string) => {
      log.showWarn(`get form displayName: ${value}`);
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        this.mDisplayName = this.mAppName;
        return;
      }
      this.mDisplayName = value;
    });
  }

  private destroyViewData(): void {
    log.showInfo('destroyViewData');
    this.mStartFormInfo = new CardItemInfo();
  }

  private getFormEditContentHeight(): number {
    let contentHeight: number = 2 * FormStyleConstants.FORM_DESCRIPTION_DEFAULT_MARGIN + this.mFormHeight +
    FormStyleConstants.FORM_EDIT_VIEW_CARD_NAME_HEIGHT + FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN +
    this.mViewData.formAppEditHeight;
    return Math.max(contentHeight, this.getFormEditScrollHeight());
  }

  private getFormEditScrollHeight(): number {
    return this.mViewData.bindSheetHeight -
      (FormStyleConstants.FORM_EDIT_VIEW_TITLE_HEIGHT + this.mViewData.isButtonMarginBottom +
      FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT + FormStyleConstants.FORM_EDIT_VIEW_CARD_NAME_HEIGHT);
  }

  aboutToAppear(): void {
    log.showInfo('FormEditView aboutToAppear');
    this.mFormEditViewData.updateViewDate(this.mIsPortrait);
    this.mFormEditViewManager.registerFormEditViewController(this.mViewController);
  }

  aboutToDisappear(): void {
    log.showInfo('FormEditView aboutToDisappear');
    this.mFormEditViewManager.unRegisterFormEditViewController();
    // 发送事件通知销毁动效组件
    GlobalContext.getContext()?.eventHub?.emit(CommonConstants.EVENTHUB_FORM_EDIT_EXIT);
  }

  @Builder
  titleBarBuilder() {
    Row() {
      Image(this.mAppIcon)
        .draggable(false)
        .id(`${TAG}_Image_${this.mAppName}`)
        .width(40)
        .height(40)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(8)

      Text(this.mAppName)
        .id(`${TAG}_Text_${this.mAppName}`)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(FontWeight.Bold)
        .height(26)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .margin({ start: LengthMetrics.vp(8) })
        .textAlign(TextAlign.Start)
        .maxFontScale(1.45)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height(FormStyleConstants.FORM_EDIT_VIEW_TITLE_HEIGHT)
  }

  @Builder
  cardName() {
    Text(this.mDisplayName)
      .id(`${TAG}_CARD_NAME_${this.mDisplayName}`)
      .draggable(false)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontSize($r('sys.float.Title_M'))
      .fontWeight(FontWeight.Bold)
      .height(FormStyleConstants.FORM_NAME_TEXT_HEIGHT)
      .maxLines(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .margin({
        left: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN,
        top: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN,
        right: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN,
        bottom: this.isOuterDesktop ? 0 : FormStyleConstants.FORM_DESCRIPTION_DEFAULT_MARGIN
      })
      .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
  }

  @Builder
  buttonBuilder() {
    Button({ type: ButtonType.Capsule }) {
      Text($r('app.string.form_center_notice_button'))
        .fontSize($r('sys.float.ohos_id_text_size_button1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
        .height(FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT_TEXT)
    }
    .id(`${TAG}_finishButton`)
    .width(this.mViewData.formEditButtonWidth)
    .height(FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT)
    .padding({
      top: FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_PADDING,
      bottom: FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_PADDING,
    })
    .margin({
      left: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN,
      right: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN,
      bottom: this.mViewData.isButtonMarginBottom,
    })
    .onClick(() => {
      // 点击完成按钮收起编辑页
      this.closeView();
    })
  }

  @Builder
  formEditBuilder() {
    Column() {
      Scroll() {
        Column() {
          // 卡片别名
          this.cardName()

          if (this.isOuterDesktop) {
            // 应用编辑页
            AppEditPageView({
              mStartFormInfo: this.mStartFormInfo,
              previewCardId: this.previewCardId,
              mViewData: this.mViewData,
              isOuterDesktop: this.isOuterDesktop
            })
          } else {
            // 预览图
            FormEditPreview({
              mFormItem: this.mStartFormInfo,
              mFormWidth: this.mFormWidth,
              mFormHeight: this.mFormHeight,
              mFormScale: this.mFormScale,
              onAcquired: (cardId: string) => {
                this.previewCardId = cardId;
                //previewCardId被赋值之后再拉起UIExtensionComponent
                this.isLoadFinish = true;
              }
            })
            // 应用编辑页
            if (this.isLoadFinish) {
              AppEditPageView({
                mStartFormInfo: this.mStartFormInfo,
                previewCardId: this.previewCardId,
                mViewData: this.mViewData,
                isOuterDesktop: this.isOuterDesktop
              })
            }
          }
        }
      }
      .height(this.getFormEditScrollHeight())
      .margin({ bottom: FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN })
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .nestedScroll({ scrollForward: NestedScrollMode.SELF_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
      .onScrollStart(() => {
        // 打断一镜到底动效
        GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
      })

      // 按钮
      this.buttonBuilder()
    }
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Stack()
      .id(`${TAG}_Stack`)
      .position({ x: 0, y: 0 })
      .bindSheet(this.mEditViewShow, this.formEditBuilder(), {
        title: this.titleBarBuilder(),
        width: this.mViewData.bindSheetWidth,
        height: this.mViewData.bindSheetHeight,
        showClose: true,
        dragBar: false,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        backgroundColor: Color.Transparent,
        detents: [this.mBindSheetHeight, 0],
        mode: SheetMode.EMBEDDED,
        preferType: this.mViewData.sheetType,
        onWillAppear: () => {
          TraceUtil.startTrace(DomainName.SCB, FormConstants.FORM_EDIT_VIEW_ENTER);
          log.showInfo('form edit will show.');
          AppStorage.setOrCreate<string>('userEditFormId', this.mStartFormInfo.cardId);
        },
        onAppear: () => {
          TraceUtil.endTrace(DomainName.SCB, FormConstants.FORM_EDIT_VIEW_ENTER);
          log.showWarn('form edit onAppear');
        },
        onWillDisappear: () => {
          TraceUtil.startTrace(DomainName.SCB, FormConstants.FORM_EDIT_VIEW_EXIT);
          log.showInfo('form edit will disappear.');
          this.mEditViewShow = false;
          this.detentsDidChange = false;
          this.closeFormEffect = false;
          // 关闭半模态打断一镜到底动效
          GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
          setTimeout(() => {
            AppStorage.setOrCreate<string>('userEditFormId', EMPTY_FORM_ID);
          }, EDIT_FORM_VALID_DURATION);
        },
        onDisappear: () => {
          TraceUtil.endTrace(DomainName.SCB, FormConstants.FORM_EDIT_VIEW_EXIT);
          log.showWarn('form edit onDisappear');
          if (!this.mEditViewShow) {
            this.destroyViewData();
          }
          this.mViewStateChangeCallback?.onHide?.(TAG);
        },
        onDetentsDidChange: () => {
          this.detentsDidChange = true;
        },
        onHeightDidChange: () => {
          if (!this.detentsDidChange && !this.closeFormEffect) {
            log.showInfo('interrupt form effect');
            GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
            this.closeFormEffect = true;
          }
          this.detentsDidChange = false;
        }
      })
  }
}

@Component
export struct FormEditPreview {
  private mFormStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
  private mFormItem: CardItemInfo = new CardItemInfo();
  private mFormWidth: number = 0;
  private mFormHeight: number = 0;
  private mFormId: string = '';
  private mFormRadius: number = 0;
  private formWant: Want = {};
  private mFormScale: number = 1;
  @State formOpacity: number = 0;
  @State formShadowColor: Resource = $r('app.color.normal_form_manager_shadow_color');
  private onAcquired: Callback<string> = (cardId: string) => {
  };

  aboutToAppear(): void {
    log.showInfo('edit preview card aboutToAppear');
    localEventManager.registerEventListener(this.mLocalEventListener, [FormConstants.FORM_EDIT_SHOW]);
    GlobalContext.getContext()?.eventHub.on('enterFormEditDone', () => {
      this.formOpacity = 1;
    })
    this.mFormRadius = this.mFormStyleConfig.getFormBorderRadius(this.mFormItem.cardDimension);
    this.formWant.parameters = {};
    this.formWant.parameters[CommonConstants.EDIT_FORM_ID] = this.mFormItem.cardId;
    if (this.mFormItem.isTransparent) {
      this.formWant.parameters[CommonConstants.FORM_BACKGROUND_TRANSPARENCY] = Color.Transparent;
    }
  }

  aboutToDisappear(): void {
    log.showInfo('edit preview card aboutToDisappear');
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    GlobalContext.getContext()?.eventHub.off('enterFormEditDone');
    FormManager.getInstance().deleteCard(this.mFormId);
  }
  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params?: number) => {
      if (event === FormConstants.FORM_EDIT_SHOW) {
        if (!CheckEmptyUtils.isEmpty(params)) {
          this.formOpacity = 1;
          this.formShadowColor = $r('app.color.gradient_form_manager_shadow_color');
          animateTo({
            delay: params,
            duration: 250,
            curve: Curve.Sharp,
            onFinish: () => {
              this.formShadowColor = $r('app.color.normal_form_manager_shadow_color');
            }
          }, () => {
            this.formShadowColor = $r('app.color.normal_form_manager_shadow_color');
          })
        } else {
          this.formOpacity = 0;
        }
      }
    }
  }

  @Styles
  CommonStyles() {
    .size({ width: GridLayoutUtil.getFloorVp(this.mFormWidth), height: GridLayoutUtil.getFloorVp(this.mFormHeight) })
    .scale({ x: this.mFormScale, y: this.mFormScale })
    .borderRadius(this.mFormRadius)
    .draggable(false)
    .transition(TransitionEffect.IDENTITY)
    .hoverEffect(HoverEffect.None)
    .shadow({
        radius: $r('app.float.normal_form_manager_radius'),
        color: this.formShadowColor,
        offsetY: $r('app.float.normal_form_manager_offset')
      })
    .opacity(this.formOpacity)
    .backgroundColor(this.mFormItem.isTransparent ?
      $r('app.color.transparent_form_background_color') : Color.Transparent)
  }

  build() {
    Stack() {
      FormComponent({
        id: FormCommonUtil.transformCardId(this.mFormId),
        name: this.mFormItem.cardName,
        bundle: this.mFormItem.bundleName,
        ability: this.mFormItem.abilityName,
        module: this.mFormItem.moduleName,
        dimension: this.mFormItem.cardDimension,
        want: this.formWant,
      })
        .id(`${TAG}_FormEditPreview_${this.mFormItem.bundleName}`)
        .CommonStyles()
        .onAcquired((form: FormCallbackInfo) => {
          if (!form) {
            log.showError('edit preview card onAcquired invalid!');
            return;
          }
          this.mFormId = form.idString;
          this.onAcquired(this.mFormId);
          log.showInfo(`form edit onAcquired: ${this.mFormId}`);
        })
        .onError(async (error) => {
          log.showError(`FormEditPreview onError. code: ${error?.errcode}`);
        })
        .onLoad(() => {
          setTimeout(() => {
            AppStorage.setOrCreate('formManagerId', `${TAG}_FormEditPreview_${this.mFormItem.bundleName}`);
          }, 50);
          log.showInfo('edit preview card onload');
        })
    }
    .enabled(false)
    .hitTestBehavior(HitTestMode.Block)
    .size({
      width: GridLayoutUtil.getFloorVp(this.mFormWidth * this.mFormScale),
      height: GridLayoutUtil.getFloorVp(this.mFormHeight * this.mFormScale)
    })
    .accessibilityDescription(',')
    .onClick(() => {
      // 屏蔽点击事件，配置无障碍模式可聚焦
      return;
    })
  }
}

@Component
export struct AppEditPageView {
  private mStartFormInfo: CardItemInfo = new CardItemInfo();
  private mViewData: ViewData = new ViewData();
  private isOuterDesktop: boolean = false;
  @Prop previewCardId: string = '';
  @State uecHeight: number | string = '100%';
  @State uecLayoutWeight: number | string = 1;

  private getAbilityName(): string | undefined {
    return this.mStartFormInfo.formConfigAbility?.slice(CommonConstants.FORM_CONFIG_ABILITY_PREFIX.length);
  }

  aboutToAppear(): void {
    log.showWarn('AppEditPageView aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showWarn('AppEditPageView aboutToDisappear');
  }

  build() {
    UIExtensionComponent({
      bundleName: this.mStartFormInfo.bundleName,
      abilityName: this.getAbilityName(),
      parameters: {
        'ability.want.params.uiExtensionType': FormConstants.FORM_EDIT_UI_EXTENSION_TYPE,
        'cardId': this.mStartFormInfo.cardId,
        'previewCardId': this.previewCardId,
      }
    })
      .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
      .onRemoteReady((proxy: UIExtensionProxy) => {
        log.showWarn('UIExtensionComponent onRemoteReady');
      })
      .onTerminated((info: TerminationInfo) => {
        log.showWarn('UIExtensionComponent onTerminated');
      })
      .onReceive((data) => {
        log.showInfo(`onReceive: ${data?.uecHeight}`);
        if (data?.uecHeight) {
          this.uecHeight = Number(data.uecHeight);
          this.uecLayoutWeight = 0;
        }
      })
      .onError((err) => {
        log.showError(`UIExtensionComponent onError, code: ${err?.code}`);
      })
      .id(`${TAG}_AppEditPageView`)
      .clip(true)
      .size({ width: this.mViewData.formAppEditWidth, height: this.uecHeight })
      .layoutWeight(this.uecLayoutWeight)
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        if (gestureInfo.type == GestureControl.GestureType.PAN_GESTURE) {
          // 设置手势拦截，UEC外部组件不响应滚动
          if (this.isOuterDesktop) {
            log.showInfo('UIExtensionComponent PanGesture onAction');
            return GestureJudgeResult.CONTINUE;
          }
        }
        return GestureJudgeResult.REJECT;
      })
      .width('calc(100% - 32vp)')
      .margin({
        start: LengthMetrics.vp(16),
        top: this.isOuterDesktop ? LengthMetrics.vp(0) : LengthMetrics.vp(32),
        end: LengthMetrics.vp(16),
        bottom: this.isOuterDesktop ? LengthMetrics.vp(0) : LengthMetrics.vp(32),
      })
      .backgroundColor(Color.Transparent)
  }
}