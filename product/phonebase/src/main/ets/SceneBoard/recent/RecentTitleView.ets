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

import { LengthMetrics } from '@kit.ArkUI';
import { AppItemInfo } from '@ohos/launchercommon';
import {
  NeedRenderPos,
  NeedRenderScale,
  NeedRenderTitleViewAlpha,
  SCBSceneContainerSession,
  scbEventExclusiveManager,
  EventType,
  SCBScreenProperty,
  RecentsStyleConstants,
  ResUtils,
  NeedRenderLockIconOpacity,
  NeedRenderLockIconScale,
  NeedRenderLockIconTranslate,
  NeedRenderTitleViewScale
} from '@ohos/windowscene';
import { LogDomain, LogHelper} from '@ohos/basicutils'
import { HiSysEventUtil} from '@ohos/frameworkwrapper';
import { RecentsStyleConfig} from '@ohos/recents';
import { RecentTitleInfo, RecentTitleViewModel } from './viewmodel/RecentTitleViewModel';
import { SCBScenePanelFSM } from './scenepanel/SCBScenePanelFSM';
import { RecentClickReason } from './scenepanel/ScenePanelStates';
import { RecentIconConstants } from './common/constants/RecentIconConstants';
import { RecentLockIconModel } from './scenepanel/recentpanel/RecentLockIconModel';
import { RecentLayoutManager } from './common/RecentLayoutManager';
import { LockType } from './scenepanel/recentpanel/RecentAccessibilityUtils';

const TAG = 'RecentTitleView';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * RecentCardTitle
 */
@Component
export struct RecentTitleView {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderScale: NeedRenderScale;
  @ObjectLink needRenderPos: NeedRenderPos;
  @ObjectLink titleViewAlpha: NeedRenderTitleViewAlpha;
  @ObjectLink screenProperty: SCBScreenProperty;
  @ObjectLink needRenderLockIconOpacity: NeedRenderLockIconOpacity;
  @ObjectLink needRenderLockIconScale: NeedRenderLockIconScale;
  @ObjectLink needRenderLockIconTranslate: NeedRenderLockIconTranslate;
  @ObjectLink needRenderTitleViewScale: NeedRenderTitleViewScale;
  @State primaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();
  @State secondaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();
  private recentTitleViewModel: RecentTitleViewModel =
    new RecentTitleViewModel(this.screenProperty, this.primaryRecentTitleInfo, this.secondaryRecentTitleInfo);

  aboutToAppear(): void {
    this.recentTitleViewModel.init();
    this.recentTitleViewModel.initRecentData(this.sceneContainerSession);
    this.sceneContainerSession.setUpdateTitleViewCallback(() => {
      this.recentTitleViewModel.updateRecentData(this.sceneContainerSession);
    });
  }

  aboutToDisappear(): void {
    this.sceneContainerSession.setUpdateTitleViewCallback(undefined);
  }

  private lockIconClick(): void {
    RecentLockIconModel.lockIconDisAppearAnimate(this.sceneContainerSession, this.primaryRecentTitleInfo.name);
    RecentLockIconModel.reportSlideLock(this.sceneContainerSession, LockType.UNLOCK);
  }

  /**                                     多任务标题布局
   *                     |__________________标题宽度_________________|
   *                     |____primary_____|        |___secondary___|
   *      |__marginLeft__|__图标__|__标题__|_间隔(8)_|__图标__|__标题__|__marginRight__|
   *
   *       __________________________________________________________________________
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                       recent mission card                               |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |                                                                         |
   *      |_________________________________________________________________________|
   */
  build() {
    Row() {
      if (this.sceneContainerSession.primarySession) {
        this.doPrimaryAppIconBuild();
        this.primaryAppNameBuild();
      }

      if (this.sceneContainerSession.secondarySession) {
        this.doSecondAppIconBuild();
        this.secondAppNameBuild();
      }

      if (this.sceneContainerSession.isAppLockedForbidDelete) {
        this.lockIconBuild();
      }
    }
    .scale({
      x: this.needRenderTitleViewScale.titleViewScale,
      y: this.needRenderTitleViewScale.titleViewScale,
      centerX: '50%',
      centerY: '50%'
    })
    .accessibilityLevel('no')
    .opacity(this.titleViewAlpha.titleViewAlpha)
    .position(RecentTitleViewModel.getTitlePosition(this.sceneContainerSession, this.screenProperty,
      this.needRenderScale, this.needRenderPos))
    .width(RecentLayoutManager.getTitleWidth(this.screenProperty))
    .margin(RecentLayoutManager.getTitleMargin())
    .id(RecentTitleViewModel.getTitleId(TAG, this.primaryRecentTitleInfo.appInfo,
      this.secondaryRecentTitleInfo.appInfo))
    .onClick(() => {
      if (!this.sceneContainerSession.primarySession ||
      scbEventExclusiveManager.isExclusive(EventType.RECENT_CARD_CLICK)) {
        return;
      }
      let bundleName = this.sceneContainerSession.primarySession?.sceneInfo.bundleName;
      if (this.sceneContainerSession.secondarySession) {
        bundleName += ' || ' + this.sceneContainerSession.secondarySession.sceneInfo.bundleName;
      }
      log.showInfo(`recent title clicked. start scene from recent: ${bundleName}`);
      SCBScenePanelFSM.getInstance().onClick(RecentClickReason.START_APP, this.sceneContainerSession);
      HiSysEventUtil.reportGoIntoAppByTitleInRecent(bundleName);
    })
  }

  @Builder
  primaryAppIconBuild() {
    Image(this.primaryRecentTitleInfo.icon)
      .id(this.recentTitleViewModel.primaryIconId)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .margin({ start: LengthMetrics.vp(0) })
      .appIconStyles()
  }

  @Builder
  primaryAppIconBuildWithIndex() {
    RelativeContainer() {
      this.primaryAppIconBuild();
      Image(this.recentTitleViewModel.subPrimaryIconImage)
        .width(RecentIconConstants.SUB_ICON_SIZE)
        .height(RecentIconConstants.SUB_ICON_SIZE)
        .syncLoad(true)
        .alignRules({
          right: { anchor: this.recentTitleViewModel.primaryIconId, align: HorizontalAlign.End },
          bottom: { anchor: this.recentTitleViewModel.primaryIconId, align: VerticalAlign.Bottom }
        })
        .offset(RecentIconConstants.SUB_ICON_OFFSET)
    }
    .margin({ start: LengthMetrics.vp(0) })
    .appIconWithIndexStyles()
  }

  @Builder
  doPrimaryAppIconBuild() {
    if (this.primaryRecentTitleInfo.appInfo?.appIndex === 0) {
      this.primaryAppIconBuild();
    } else {
      this.primaryAppIconBuildWithIndex();
    }
  }

  @Builder
  lockIconBuild() {
    Row() {
      this.lockIconGraphBuild()
    }.width(RecentsStyleConfig.getInstance().lockIconClickHotAreaSize)
    .height(RecentsStyleConfig.getInstance().lockIconClickHotAreaSize)
    .position({start: LengthMetrics.vp(0),
      top: LengthMetrics.vp(-RecentsStyleConfig.getInstance().lockIconClickHotAreaPadding)})
    .margin({
      start: LengthMetrics.vp(RecentLockIconModel.getLockIconMarginStart(this.screenProperty,
        this.needRenderTitleViewScale.titleViewScale))
    })
    .padding(RecentsStyleConfig.getInstance().lockIconClickHotAreaPadding)
    .accessibilityText(ResUtils.getInnerStringNumS($r('app.string.recent_unlock'), this.primaryRecentTitleInfo.name))
    .accessibilityLevel('yes')
    .onClick(() => {
      this.lockIconClick();
      log.showInfo('lock icon clicked.');
    })
  }

  @Builder
  lockIconGraphBuild() {
    SymbolGlyph($r('sys.symbol.lock'))
      .draggable(false)
      .fontWeight(FontWeight.Regular)
      .fontColor(['#E5FFFFFF'])
      .fontSize(RecentsStyleConfig.getInstance().lockIconFontsize)
      .scale({
        x: this.needRenderLockIconScale.lockIconScale,
        y: this.needRenderLockIconScale.lockIconScale,
        centerX: this.needRenderLockIconScale.lockIconCenter,
        centerY: this.needRenderLockIconScale.lockIconCenter
      })
      .opacity(this.needRenderLockIconOpacity.lockIconOpacity)
      .translate({x: this.needRenderLockIconTranslate.lockIconTranslateX,
        y: this.needRenderLockIconTranslate.lockIconTranslateY})
  }

  @Builder
  secondAppIconBuild() {
    Image(this.secondaryRecentTitleInfo.icon)
      .id(this.recentTitleViewModel.secondaryIconId)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .margin({ start: LengthMetrics.vp(RecentsStyleConfig.getInstance().recentSpaceBetweenTitle) })
      .appIconStyles()
  }

  @Builder
  secondAppIconBuildWithIndex() {
    RelativeContainer() {
      Image(this.secondaryRecentTitleInfo.icon)
        .id(this.recentTitleViewModel.secondaryIconId)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .appIconStyles()
      Image(this.recentTitleViewModel.subSecondaryIconImage)
        .width(RecentIconConstants.SUB_ICON_SIZE)
        .height(RecentIconConstants.SUB_ICON_SIZE)
        .syncLoad(true)
        .alignRules({
          right: { anchor: this.recentTitleViewModel.secondaryIconId, align: HorizontalAlign.End },
          bottom: { anchor: this.recentTitleViewModel.secondaryIconId, align: VerticalAlign.Bottom }
        })
        .offset(RecentIconConstants.SUB_ICON_OFFSET)
    }
    .margin({ start: LengthMetrics.vp(RecentsStyleConfig.getInstance().recentSpaceBetweenTitle) })
    .appIconWithIndexStyles()
  }

  @Builder
  doSecondAppIconBuild() {
    if (this.secondaryRecentTitleInfo.appInfo?.appIndex === 0) {
      this.secondAppIconBuild();
    } else {
      this.secondAppIconBuildWithIndex();
    }
  }

  @Builder
  primaryAppNameBuild() {
    Text(this.primaryRecentTitleInfo.name)
      .id(`${TAG}_Text_${this.primaryRecentTitleInfo.appInfo?.bundleName}`)
      .fontSize(RecentTitleViewModel.getFontScaleState(this.recentTitleViewModel.fontScaleState))
      .fontColor(RecentsStyleConstants.DEFAULT_FONT_COLOR)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .margin({ start: LengthMetrics.vp(RecentsStyleConstants.LEFT_MARGIN_BETWEEN_ICON_NAME) })
      .appNameStyles()
  }

  @Builder
  secondAppNameBuild() {
    Text(this.secondaryRecentTitleInfo.name)
      .id(`${TAG}_Text_${this.secondaryRecentTitleInfo.appInfo?.bundleName}`)
      .fontSize(RecentTitleViewModel.getFontScaleState(this.recentTitleViewModel.fontScaleState))
      .fontColor(RecentsStyleConstants.DEFAULT_FONT_COLOR)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .margin({ start: LengthMetrics.vp(RecentsStyleConstants.LEFT_MARGIN_BETWEEN_ICON_NAME) })
      .appNameStyles()
  }

  @Styles
  appIconStyles() {
    .draggable(false)
    .borderRadius(RecentsStyleConstants.RECENT_APP_ICON_BORDER_RADIUS)
    .width(RecentsStyleConfig.getInstance().mAppIconSize)
    .height(RecentsStyleConfig.getInstance().mAppIconSize)
    .accessibilityLevel('no')
  }

  @Styles
  appIconWithIndexStyles() {
    .height(RecentsStyleConfig.getInstance().mAppIconSize)
    .width(RecentsStyleConfig.getInstance().mAppIconSize)
    .accessibilityLevel('no-hide-descendants')
  }

  @Styles
  appNameStyles() {
    .draggable(false)
    .constraintSize({ maxWidth: this.recentTitleViewModel.maxWidth })
    .accessibilityLevel('no')
  }
}