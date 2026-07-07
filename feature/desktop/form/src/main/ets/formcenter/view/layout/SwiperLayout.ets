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
import { AttributeUpdater, } from '@ohos.arkui.modifier';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo } from '@ohos/launchercommon';
import { SCBScenePanelManager, ResUtils } from '@ohos/windowscene';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { fontSizeScaleUtils } from '../../util/FontSizeScaleUtils';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { FormItemFactory } from '../../viewmodel/factory/FormItemFactory';
import { FormCenterFormItem } from '../atomicview/formitem/FormCenterFormItem';
import { SwiperLayoutEventInterface } from '../../interfaces/SwiperLayoutEventInterface';
import { SwiperLayoutViewData } from '../../viewmodel/data/SwiperLayoutViewData';
import { SwiperLayoutStyle } from '../../viewstyles/SwiperLayoutStyle';
import FormDescription from '../atomicview/FormDescription';
import { FormDescriptionVm } from '../../viewmodel/data/FormDescriptionVm';
import { SearchStateMgr } from '../atomicview/SearchComponent';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';
import { LazyDataSource } from '@ohos/launchercommon/src/main/ets/uicomponents/LazyDataSource';

const TAG = 'SwiperLayout';
const LOADING_DEFAULT_SIZE = 24;
const LOADING_MAX_SIZE_SCALE = 1.45;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct SwiperLayout {
  public mViewData?: SwiperLayoutViewData;
  public style: SwiperLayoutStyle = new SwiperLayoutStyle();
  public mEvent?: SwiperLayoutEventInterface;
  public swiperAttributeUpdater: AttributeUpdater<CommonAttribute> = new AttributeUpdater();
  @State formDescriptionVm: FormDescriptionVm = new FormDescriptionVm();
  @State currentIndex: number = 0;
  @State isLoading: boolean = false;
  @State loadingSize: number = LOADING_DEFAULT_SIZE;
  @State isNegativeSupportDimension: boolean = false;
  @State @Watch('onSearchResultChange') searchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  @ObjectLink mBindSheetViewData: NavDestinationViewData;
  @Consume mStartFormInfo: CardItemInfo;
  private formCenterReaderText: string = '';
  private fadeInAnimation: boolean = false;
  private refreshSearchResultFlag: boolean = SearchStateMgr.getInstance().refreshFlag;
  private appFormDataSource: LazyDataSource<CardItemInfo> = new LazyDataSource<CardItemInfo>();

  aboutToAppear(): void {
    log.showInfo(`FormSwipeLayoutStyle aboutToAppear ${this.mViewData?.mStartFormInfo?.bundleName}`);
    this.currentIndex = this.mViewData?.swipeTargetIndex ?? 0;
    this.appFormDataSource = new LazyDataSource<CardItemInfo>(this.mViewData?.appFormList ?? []);
    this.style.adaptDescription(this.mBindSheetViewData.cardViewMargin);
    this.mEvent?.onAppear();
    if (this.mEvent?.getThemeFromLoading) {
      this.isLoading = this.mEvent?.getThemeFromLoading();
      const fontSizeScale = fontSizeScaleUtils.getFontSizeScale();
      this.loadingSize = fontSizeScale > LOADING_MAX_SIZE_SCALE ? LOADING_DEFAULT_SIZE * LOADING_MAX_SIZE_SCALE :
        LOADING_DEFAULT_SIZE * fontSizeScale;
    }
    this.updateAccFormDescription();
    if (this.mViewData?.isAddToNegativeScreen) {
      this.isNegativeSupportDimension = this.mEvent?.getButtonStatusForNegativeScreen() || false;
    }
    const slideText: string = ResUtils.getInnerString($r('app.string.accessibility_str_two_finger_slide'));
    const dragText: string = ResUtils.getInnerString($r('app.string.accessibility_str_long_click_to_drag'));
    this.formCenterReaderText = `${slideText}, ${dragText}`;
  }

  aboutToDisappear(): void {
    this.mEvent?.onDisAppear();
  }

  private onSearchResultChange(): void {
    if (this.refreshSearchResultFlag === this.searchStateMgr.refreshFlag) {
      return;
    }

    this.refreshSearchResultFlag = SearchStateMgr.getInstance().refreshFlag;
    let formList: CardItemInfo[] = this.mViewData?.appFormList ?? [];
    let oldIndex: number = this.currentIndex;
    this.currentIndex = FormCenterViewModel.getInstance().getAppFormsIndexWhenSearch(formList);
    this.mEvent?.onSwiperChange(this.currentIndex, oldIndex);
    log.showDebug(`${formList[0]?.bundleName} update search result index: ${this.currentIndex}`);
  }

  private updateAccFormDescription(): void {
    this.mEvent?.getDescriptionEvent(this.currentIndex).updateFormDescriptionVm(this.formDescriptionVm,
      this.mViewData?.appFormList[this.currentIndex] ?? new CardItemInfo())
  }

  @Builder
  addFormButton() {
    Button(this.style.buttonOptions) {
      Row() {
        LoadingProgress()
          .width(this.loadingSize)
          .height(this.loadingSize)
          .color(0xFFFFFF)
          .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
        Text(this.style.buttonText)
          .fontSize(this.style.buttonTextSize)
          .fontColor(this.style.buttonTextColor)
          .fontWeight(this.style.buttonTextWeight)
          .maxFontScale(this.style.maxFontScale)
          .height(this.style.buttonTextHeight)
          .maxLines(this.style.addToDeskTopMaxLines)
          .textOverflow(this.style.addToDeskTopTextOverflow)
          .visibility(this.isLoading ? Visibility.None : Visibility.Visible)
      }
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor(this.style.buttonBgColor)
    .id(`${TAG}_AddToDesktopButton`)
    .height(this.style.buttonHeight)
    .width(this.style.buttonWidth ?? this.mBindSheetViewData.addFormButtonWidth)
    .padding(this.style.buttonPadding)
    .onTouch((event: TouchEvent) => {
      this.mEvent?.onButtonTouch(event)
    })
    .onClick((event: ClickEvent) => {
      this.mEvent?.onButtonClick(event);
    })
    .onAppear(() => {
      log.showInfo('onAppear.');
    })
    .onDisAppear(() => {
      this.isLoading = true;
    })
  }

  @Builder
  addNegativeScreenFormButton() {
    Button({ type: ButtonType.Capsule, stateEffect: this.isNegativeSupportDimension }) {
      Text(this.style.buttonTextForNegativeScreen)
        .fontSize(this.style.buttonTextSize)
        .fontWeight(this.style.buttonTextWeight)
        .maxFontScale(this.style.maxFontScale)
        .height(this.style.buttonTextHeight)
    }
    .buttonStyle(this.mViewData?.isAsdeOpen ? this.style.buttonStyleNormal : this.style.buttonStyleEmphasized)
    .opacity(this.isNegativeSupportDimension ? this.style.buttonStyleOpacity : this.style.buttonStyleDisableOpacity)
    .enabled(this.isNegativeSupportDimension)
    .id(`${TAG}_addNegativeScreenFormButton`)
    .height(this.style.buttonHeight)
    .width(this.style.buttonWidth ?? this.mBindSheetViewData.addFormButtonWidth)
    .padding(this.style.buttonPadding)
    .onTouch((event: TouchEvent) => {
      this.mEvent?.onButtonTouch(event)
    })
    .onClick((event: ClickEvent) => {
      if (!this.mEvent?.addCardToNegativeScreen || !this.isNegativeSupportDimension) {
        return;
      }
      this.mEvent.addCardToNegativeScreen(event);
    })
  }

  @Builder
  appFormItemBuilder(index: number) {
    Column() {
      if (this.style.isShowDescription) {
        FormDescription({
          style: this.style.descriptionStyle,
          formItem: this.mViewData?.appFormList[index],
          formDescriptionEvent: this.mEvent?.getDescriptionEvent(index),
          index: index,
          freshFlag: this.searchStateMgr.refreshFlag,
        })
      }

      Column() {
        FormCenterFormItem({
          mEvent: this.mEvent?.getFormItemEvent(index),
          formItem: this.mViewData?.appFormList[index],
          idIndex: index,
          formRate: this.mBindSheetViewData.formRate,
          isFormClickableInAccess: this.style.isFormClickableInAccess,
          formDescriptionEvent: this.mEvent?.getDescriptionEvent(index),
          buildInterface: FormItemFactory.createFormItem({
            formItem: this.mViewData?.appFormList[index] ?? new CardItemInfo(),
          }),
          style: this.style.formStyle,
        })
      }
      .id(`FormItemView_Column_${index}`)
      .alignItems(this.style.formItemColumnAlignItem)
      .justifyContent(this.style.formItemColumnJustifyContent)
      .width(this.style.formItemColumnWidth)
      .height(this.mBindSheetViewData.formViewHeight)
    }
    .id(`SwiperItemView_Column_${index}`)
    .width(this.style.swiperItemColumnWidth)
    .alignItems(this.style.swiperItemAlignItem)
    .height(this.mBindSheetViewData.formViewHeight + (this.style.swiperItemHeight ?? 0))
  }

  build() {
    Column() {
      Swiper() {
        LazyForEach(this.appFormDataSource, (formItem: CardItemInfo, index: number) => {
          this.appFormItemBuilder(index)
        }, (item: CardItemInfo, index: number): string => {
          return `${this.mViewData?.appFormList.length}${index}${this.mBindSheetViewData.formRate}`;
        })
      }
      .cachedCount(1)
      .index(this.currentIndex)
      .attributeModifier(this.swiperAttributeUpdater)
      .width(this.style.swiperWidth)
      .clip(this.style.clip)
      .displayCount(this.style.disPlayCount)
      .displayMode(this.style.displayMode)
      .prevMargin(this.mBindSheetViewData.cardViewMargin)
      .nextMargin(this.mBindSheetViewData.cardViewMargin)
      .loop(this.style.loop)
      .indicator(this.style.indicator && this.mViewData?.appFormList.length && (this.mViewData?.appFormList.length > 1))
      .onChange((index: number) => {
        let oldIndex: number = this.currentIndex;
        log.showWarn('onChange index=%{public}d, old=%{public}d', index, oldIndex);
        this.currentIndex = index;
        this.mEvent?.onSwiperChange(index, oldIndex);
        this.updateAccFormDescription();
        GlobalContext.getContext()?.eventHub.emit(`notifySwipeChange_${this.mViewData?.formIdMap.get(index)}_${index}`);
      })
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        log.showInfo(`index: ${index} onGestureSwipe extraInfo.currentOffset=${extraInfo.currentOffset}`);
        this.mEvent?.onGestureSwipe(index, extraInfo);
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        if (!this.fadeInAnimation) {
          // 切换导航点 打断一镜到底动效
          GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
          this.fadeInAnimation = true;
        }
        this.mEvent?.onAnimationStart(index, targetIndex, extraInfo);
        this.mEvent?.indexChangeCallBack?.(targetIndex);
        if (this.mViewData?.isAddToNegativeScreen) {
          this.isNegativeSupportDimension = this.mEvent?.getButtonStatusForNegativeScreen() || false;
        }
      })
      .onAnimationEnd(() => {
        this.fadeInAnimation = false;
      })
      .accessibilityText(`${this.formDescriptionVm.mDisplayName}${this.formDescriptionVm.mDescription}`)
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityDescription(this.formCenterReaderText)

      Column() {
        if (this.mViewData?.isAsdeOpen) {
          if (this.mViewData?.isAddToNegativeScreen && !this.style.isLandSpace) {
            Row() {
              this.addNegativeScreenFormButton()
            }
            .margin({ bottom: this.style.twoButtonGap })

            this.addFormButton()
          } else if (this.mViewData?.isAddToNegativeScreen && this.style.isLandSpace) {
            Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
              this.addNegativeScreenFormButton()
              this.addFormButton()
            }
          } else {
            this.addFormButton()
          }
        } else if (this.mViewData?.isAddToNegativeScreen) {
          this.addNegativeScreenFormButton()
        } else {
          this.addFormButton()
        }
      }
      .width(this.mBindSheetViewData.addFormButtonWidth)
      .height(this.style.buttonColumnHeight)
      .margin(this.style.buttonColumnMargin)
      .alignItems(HorizontalAlign.Center)
    }
    .height(this.mBindSheetViewData.viewHeight)
    .width('100%')
  }
}