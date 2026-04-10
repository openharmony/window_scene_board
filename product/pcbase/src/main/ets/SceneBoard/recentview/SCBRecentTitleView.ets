/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { AppItemInfo } from '@ohos/launchercommon';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { MemoryHelper, SCBRecentSessionsViewModel } from './SCBRecentSessionsViewModel';
import { SCBRecentTitleViewModel } from './SCBRecentTitleViewModel';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils, SingleContext,
} from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  NeedRenderTitleViewAlpha,
  SCBSceneMode,
  NeedRenderRecentTitleTranslate,
  NeedRenderShowRecentTitle,
  NeedRenderRecentTitleWidth,
  SCBSceneSession,
  SCBScreenProperty,
} from '@ohos/windowscene';
import {
  NeedRenderRecentHoverState
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LengthMetrics } from '@kit.ArkUI';
import { SCBRecentHoverViewModel } from './SCBRecentHoverViewModel';

const TAG = 'SCBRecentViewTitle';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const PERCENTAGE_100: number = 100;

/**
 * SCBRecentViewTitle
 */
@Component
export struct SCBRecentTitleView {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderTitleViewAlpha: NeedRenderTitleViewAlpha;
  @ObjectLink needRenderRecentTitleTranslate: NeedRenderRecentTitleTranslate;
  @ObjectLink @Watch('updateData') needRenderShowRecentTitle: NeedRenderShowRecentTitle;
  @ObjectLink @Watch('calcNameMaxWidth') needRenderRecentTitleWidth: NeedRenderRecentTitleWidth;
  @ObjectLink sceneSession: SCBSceneSession | null | undefined;
  @StorageLink('isMouseCross') isMouseCross: boolean = false;
  @ObjectLink @Watch('hoverStateChange') needRenderRecentHoverState: NeedRenderRecentHoverState;
  @State deleteButtonBgColor: ResourceColor = SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_COLOR;
  @State primaryItemInfo: AppItemInfo | null = null;
  @State secondaryItemInfo: AppItemInfo | null = null;
  @State primaryIcon: string | ResourceStr | PixelMap = '';
  @State secondaryIcon: string | ResourceStr | PixelMap = '';
  @State @Watch('calcNameMaxWidth') primaryName: string = '';
  @State @Watch('calcNameMaxWidth') secondaryName: string = '';
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State primaryNameMaxWidth: number = 0;
  @State secondaryNameMaxWidth: number = 0;
  @State closeImageVisible: boolean = false;
  @State primaryPersistentId: number = 0;
  @State secondaryPersistentId: number = 0;
  @ObjectLink screenProperty: SCBScreenProperty;
  deleteSceneCardInRecent: Function = (): void => {};
  @Prop singleContext?: SingleContext;

  updateData(): void {
    log.showInfo('updateData %{public}s, %{public}s', this.sceneSession?.sceneInfo.bundleName,
      this.needRenderShowRecentTitle.showRecentTitle);
    if (this.needRenderShowRecentTitle.showRecentTitle) {
      this.initRecentDataList();
    }
  }

  private async initRecentDataList(): Promise<void> {
    await this.initPrimaryItemInfo();
    await this.initSecondaryItemInfo();
    this.updateIconAndName();
    this.calcNameMaxWidth();
    log.showInfo(`initRecentDataList ${this.primaryItemInfo?.bundleName} ${this.secondaryItemInfo?.bundleName}`);
  }

  private async initPrimaryItemInfo(): Promise<void> {
    if (this.sceneSession) {
      this.primaryItemInfo = await SCBRecentTitleViewModel.getSession(this.sceneSession);
      this.primaryPersistentId = this.sceneSession.session.persistentId;
    }
  }

  private async initSecondaryItemInfo(): Promise<void> {
    if (this.sceneContainerSession?.secondarySession && !this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      const secondaryAppInfo = await SCBRecentTitleViewModel.getSession(this.sceneContainerSession?.secondarySession);
      if (this.sceneContainerSession?.secondarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        this.secondaryItemInfo = this.primaryItemInfo;
        this.secondaryPersistentId = this.sceneContainerSession?.primarySession?.session.persistentId as number;
        this.primaryItemInfo = secondaryAppInfo;
        this.primaryPersistentId = this.sceneContainerSession?.secondarySession?.session.persistentId;
      } else {
        this.secondaryItemInfo = secondaryAppInfo;
        this.secondaryPersistentId = this.sceneContainerSession?.secondarySession?.session.persistentId;
      }
    }
  }

  private getPrimaryTitleWidth(isHovered: boolean = true): number {
    if (!this.sceneContainerSession?.secondarySession) {
      return this.needRenderRecentTitleWidth.width -
        (isHovered ? SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_RIGHT_MARGIN : 0);
    }
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair &&
      this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      return this.needRenderRecentTitleWidth.primaryWidth -
        (isHovered ? SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_RIGHT_MARGIN : 0);
    }
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair &&
      this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      return this.needRenderRecentTitleWidth.secondaryWidth -
        (isHovered ? SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_RIGHT_MARGIN : 0);
    }
    return this.needRenderRecentTitleWidth.width * parseFloat(this.sceneContainerSession.dividerParam.primary.width) /
      PERCENTAGE_100 - SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_LEFT_MARGIN;
  }

  private hoverStateChange(): void {
    this.closeImageVisible = SCBRecentTitleViewModel.checkIsHovered(this.sceneContainerSession,
      this.sceneSession, this.isMouseCross);
    log.showInfo(`hoverStateChange ${this.sceneContainerSession.needRenderRecentHoverState.hoverState} ${this.sceneSession?.hoverState}`);
    this.calcNameMaxWidth();
  }

  private handleOnDeleteHover(isHover?: boolean): void {
    this.deleteButtonBgColor = isHover ? SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_HOVER_COLOR :
    SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_COLOR;
  }

  private handleOnDeleteTouch(event?: TouchEvent): void {
    if (event?.type === TouchType.Down) {
      log.showInfo(`screenId: ${this.screenProperty?.screenId} delete icon onTouch down`);
      this.deleteButtonBgColor = SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_PRESS_COLOR;
    }
    if (event?.type === TouchType.Up) {
      log.showInfo(`screenId: ${this.screenProperty?.screenId} delete icon onTouch up`);
      this.deleteButtonBgColor = SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_COLOR;
    }
  }

  private getCloseIconVisibility(): Visibility {
    log.showDebug(`getCloseIconVisibility:  closeImageVisible: ${this.closeImageVisible}`);
    return this.closeImageVisible ? Visibility.Visible : Visibility.Hidden;
  }

  private getRecentPosition(): TranslateOptions {
    if (!this.sceneContainerSession.primarySession) {
      return { x: 0, y: 0 };
    }
    return { x: this.needRenderRecentTitleTranslate.translateX, y: this.needRenderRecentTitleTranslate.translateY };
  }

  private getSplitRecentPositionForPair(): TranslateOptions {
    if (!this.sceneSession) {
      return { x: 0, y: 0 };
    }
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      return { x: this.needRenderRecentTitleTranslate.translateX, y: this.needRenderRecentTitleTranslate.translateY }
    } else {
      return {
        x: this.needRenderRecentTitleTranslate.secondaryTranslateX,
        y: this.needRenderRecentTitleTranslate.secondaryTranslateY
      }
    }
  }

  private getPosition(): TranslateOptions {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSplitRecentPositionForPair();
    } else {
      return this.getRecentPosition();
    }
  }

  private getSplitRecentWidthForPair(): number {
    if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      return this.needRenderRecentTitleWidth.primaryWidth;
    } else {
      return this.needRenderRecentTitleWidth.secondaryWidth;
    }
  }

  private getWidth(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSplitRecentWidthForPair();
    } else {
      return this.needRenderRecentTitleWidth.width;
    }
  }

  /**
   * The callback of recent sessions app icon.
   *
   * @param {string} image - the value get from ResourceManager
   */
  private updateIconCallback(image: string | PixelMap | Resource, isPrimarySession: boolean): void {
    if (isPrimarySession) {
      this.primaryIcon = image;
      log.showInfo('primaryIcon load success');
    } else {
      this.secondaryIcon = image;
      log.showInfo('secondaryIcon load success');
    }
  }

  private getNameFontSize(): string {
    return this.fontScaleState.getRecentScaleSize(SCBRecentStyleConstants.DEFAULT_APP_NAME_SIZE);
  }

  /**
   * 当超出限制值时，设定secondary的最小值，优先保证primary
   */
  private calcNameMaxWidth(): void {
    const allWidth = this.getWidth();
    const closeWidth = SCBRecentTitleViewModel.getCloseWidth(this.sceneContainerSession, this.sceneSession,
      this.isMouseCross);
    const primaryNameWidth = SCBRecentTitleViewModel.getTextWidth(this.primaryName, this.getNameFontSize());
    const primaryFixedWidth = SCBRecentStyleConstants.RECENT_ICON_SIZE + SCBRecentStyleConstants.APP_NAME_MARGIN;
    // 二分屏container
    if (this.sceneContainerSession?.secondarySession && !this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      const secondaryFixedWidth = SCBRecentStyleConstants.DOUBLE_LIST_APP_GAP +
        SCBRecentStyleConstants.RECENT_ICON_SIZE + SCBRecentStyleConstants.APP_NAME_MARGIN;
      const sumNameWidth = allWidth - closeWidth - secondaryFixedWidth - primaryFixedWidth;
      // 上下二分屏
      if (this.sceneContainerSession.dividerParam.isUpDownSplit()) {
        this.primaryNameMaxWidth = sumNameWidth / 2;
        this.secondaryNameMaxWidth = sumNameWidth / 2;
      } else {
        // 左右二分屏
        const secondaryNameWidth = SCBRecentTitleViewModel.getTextWidth(this.secondaryName, this.getNameFontSize());
        const secondaryMinNameWidth = SCBRecentTitleViewModel.getSecondaryMinNameWidth(this.sceneContainerSession,
          this.sceneSession, this.isMouseCross, this.getNameFontSize());
        if (primaryNameWidth + secondaryNameWidth < sumNameWidth) {
          this.primaryNameMaxWidth = primaryNameWidth;
          this.secondaryNameMaxWidth = sumNameWidth - primaryNameWidth;
        } else {
          this.primaryNameMaxWidth = Math.min(primaryNameWidth, sumNameWidth - secondaryMinNameWidth)
          this.secondaryNameMaxWidth = sumNameWidth - this.primaryNameMaxWidth;
        }
      }
    } else {
      this.primaryNameMaxWidth = allWidth - closeWidth - primaryFixedWidth;
    }
    log.showDebug('calcNameMaxWidth %{public}d,%{public}d, %{public}d, %{public}s, %{public}d, %{public}s, %{public}d ',
      allWidth, closeWidth, primaryNameWidth, this.primaryName, this.primaryNameMaxWidth, this.secondaryName,
      this.secondaryNameMaxWidth);
  }

  private updateNameCallback(name: string, isPrimarySession: boolean): void {
    if (CheckEmptyUtils.isEmpty(name)) {
      return;
    }
    if (isPrimarySession) {
      this.primaryName = name;
    } else {
      this.secondaryName = name;
    }
  }

  /**
   * Update the app icon of recent sessions.
   */
  private updatePrimaryIconAndName(): void {
    SCBRecentTitleViewModel.updateIconAndName(this.primaryItemInfo, this.primaryIcon, this.primaryName,
      this.primaryPersistentId,
      (image: string | PixelMap | Resource): void => this.updateIconCallback(image, true),
      (name: string): void => this.updateNameCallback(name, true),
      this.sceneContainerSession
    );
  }

  private updateSecondaryIconAndName(): void {
    SCBRecentTitleViewModel.updateIconAndName(this.secondaryItemInfo, this.secondaryIcon, this.secondaryName,
      this.secondaryPersistentId,
      (image: string | PixelMap | Resource): void => this.updateIconCallback(image, false),
      (name: string): void => this.updateNameCallback(name, false),
      this.sceneContainerSession
    );
  }

  private updateIconAndName(): void {
    this.updatePrimaryIconAndName();
    this.updateSecondaryIconAndName();
  }

  aboutToAppear(): void {
    this.initRecentDataList();
  }

  @Builder
  primaryIconBuilder() {
    Image(this.primaryIcon)
      .draggable(false)
      .borderRadius(SCBRecentStyleConstants.RECENT_APP_ICON_BORDER_RADIUS)
      .width(SCBRecentStyleConstants.RECENT_ICON_SIZE)
      .height(SCBRecentStyleConstants.RECENT_ICON_SIZE)
      .id(`${TAG}_Image_${this.primaryItemInfo?.bundleName}`)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .syncLoad(true)
  }

  @Builder
  secondaryIconBuilder() {
    Image(this.secondaryIcon)
      .draggable(false)
      .borderRadius(SCBRecentStyleConstants.RECENT_APP_ICON_BORDER_RADIUS)
      .width(SCBRecentStyleConstants.RECENT_ICON_SIZE)
      .height(SCBRecentStyleConstants.RECENT_ICON_SIZE)
      .id(`${TAG}_Image_${this.secondaryItemInfo?.bundleName}`)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .syncLoad(true)
  }

  @Styles
  normalStyles() {
    .border({
      width: 0,
      color: '#00000000',
    })
  }

  @Builder
  primaryNameBuilder() {
    Text(this.primaryName)
      .draggable(false)
      .fontSize(this.getNameFontSize())
      .fontColor(SCBRecentStyleConstants.DEFAULT_FONT_COLOR)
      .wordBreak(WordBreak.BREAK_ALL)
      .textOverflow({overflow: TextOverflow.Ellipsis})
      .id(SCBRecentTitleViewModel.getRecentTitleAppNameId(this.primaryPersistentId, this.primaryItemInfo?.bundleName ?? ''))
      .maxLines(SCBRecentStyleConstants.DEFAULT_NAME_LINE)
      .focusable(true)
      .margin({ start: LengthMetrics.vp(SCBRecentStyleConstants.APP_NAME_MARGIN) })
      .constraintSize({maxWidth: this.primaryNameMaxWidth})
      .stateStyles({
        normal: this.normalStyles,
        focused: this.normalStyles
      })
  }

  @Builder
  secondaryNameBuilder() {
    Text(this.secondaryName)
      .draggable(false)
      .fontSize(this.getNameFontSize())
      .fontColor(SCBRecentStyleConstants.DEFAULT_FONT_COLOR)
      .wordBreak(WordBreak.BREAK_ALL)
      .textOverflow({overflow: TextOverflow.Ellipsis})
      .maxLines(SCBRecentStyleConstants.DEFAULT_NAME_LINE)
      .id(SCBRecentTitleViewModel.getRecentTitleAppNameId(this.secondaryPersistentId, this.secondaryItemInfo?.bundleName ?? ''))
      .focusable(true)
      .margin({ start: LengthMetrics.vp(SCBRecentStyleConstants.APP_NAME_MARGIN) })
      .constraintSize({maxWidth: this.secondaryNameMaxWidth})
      .stateStyles({
        normal: this.normalStyles,
        focused: this.normalStyles
      })
  }

  @Builder
  primaryBuilder() {
    Row() {
      this.primaryIconBuilder()
      this.primaryNameBuilder()
    }
    .id('title_primary_session')
  }

  @Builder
  secondaryBuilder() {
    Row() {
    }
    .id('title_split_blank')
    .width(SCBRecentStyleConstants.DOUBLE_LIST_APP_GAP)

    Row() {
      this.secondaryIconBuilder()
      this.secondaryNameBuilder()
    }
    .id('title_second_session')
  }


  @Builder
  closeIconBuilder() {
    Stack({ alignContent: Alignment.End }) {
      Stack({ alignContent: Alignment.Center }) {
        Row() {
        }
        .backgroundColor(this.deleteButtonBgColor)
        .borderRadius(SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_RADIUS)
        .width(SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH)
        .height(SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_HEIGHT)
        .visibility(this.closeImageVisible ? Visibility.Visible : Visibility.Hidden)

        SymbolGlyph(SCBRecentStyleConstants.DEFAULT_CLOSE_IMAGE)
          .id('session_close_icon')
          .draggable(false)
          .visibility(this.getCloseIconVisibility())
          .fontColor(SCBRecentStyleConstants.DEFAULT_CLOSE_COLOR)
          .fontSize(SCBRecentStyleConstants.LOCK_CLOSE_ICON_SIZE + 'vp')
          .width(SCBRecentStyleConstants.LOCK_CLOSE_ICON_SIZE)
          .height(SCBRecentStyleConstants.LOCK_CLOSE_ICON_SIZE)
      }
      .width(this.closeImageVisible ? SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_WIDTH : 0)
      .clip(true)
      .onHover((isHover?: boolean, event?: HoverEvent) => {
        log.showInfo(`delete icon onHover isHover: ${isHover}`);
        this.handleOnDeleteHover(isHover);
      })
      .onClick(() => {
        log.showInfo(`click to delete recent session ${this.sceneContainerSession.getName()}`);
        this.deleteSceneCardInRecent(this.sceneSession?.session.persistentId as number);
        MemoryHelper.getInstance(this.screenProperty.screenId).refresh();
      })
      .onTouch((event?: TouchEvent) => {
        log.showInfo('delete icon onTouch');
        this.handleOnDeleteTouch(event);
      })
    }
    .borderRadius(SCBRecentStyleConstants.RECENT_CLOSE_ICON_BACKGROUND_RADIUS)
    .focusable(false)
    .margin({
      start: LengthMetrics.vp(SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_LEFT_MARGIN)
    })
  }



  /*
  *                                   多任务标题布局
  *
  *       |____________________________标题宽度____________________________|
  *       |_____________Primary_____|           |_______Secondary_________|_Blank_|______关闭图标_____|
  *       |__图标__|_间隔(8)_|__标题__|__间隔(16)__|__图标__|_间隔(8)_|__标题__|_______|_间隔(8)_|_关闭图标_|
  *

  *       -------------------------------------------------------------------------------------------
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                 recent mission card                                     |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       |                                                                                         |
  *       -------------------------------------------------------------------------------------------
   */
  build() {
    Row() {
      this.primaryBuilder()

      if (this.sceneContainerSession?.secondarySession && !this.sceneContainerSession.dividerParam.isSplitRecentPair) {
        this.secondaryBuilder()
      }

      Blank()

      this.closeIconBuilder()
    }
    .position({x: 0, y: 0})
    .opacity(this.needRenderTitleViewAlpha.titleViewAlpha)
    .height(SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE)
    .width(this.getWidth())
    .visibility(SCBRecentTitleViewModel.getTitleVisibility(this.needRenderShowRecentTitle))
    .onHover((isHover?: boolean, event?: HoverEvent) => {
      if (!SCBRecentHoverViewModel.isCanHover(this.sceneContainerSession)) {
        log.showInfo('recent state is unStable, can not hover');
        return;
      }
      log.showInfo(`recent session title ${this.sceneSession?.getName()} onHover isHover: ${isHover}`);
      if (this.sceneSession) {
        this.sceneSession.hoverState = isHover as boolean;
      }
      SCBRecentHoverViewModel.setRecentHoverState(this.sceneContainerSession, isHover as boolean);
    })
    .onClick((event: ClickEvent) => {
      log.showInfo(`onClick happen ${event.source}  ${!AppStorage.get('isRecentCardAnimating')}`);
      // arkui的机制，当组件获取到焦点时，点击键盘的enter和space键能触发onclick事件，任务中心需屏蔽,4表示keyboard
      if (event.source === 4) {
        log.showInfo(`onClick from keyboard return`);
        return;
      }
      if (!AppStorage.get('isRecentCardAnimating')) {
        SCBSceneSessionManager.getInstance()
          .startSceneFromRecent(this.screenProperty.screenId, this.sceneSession?.session.persistentId);
        SCBSceneSessionManager.getInstance().requestFocus(this.sceneSession?.session.persistentId);
      }
    })
    .translate(this.getPosition())
  }
}
