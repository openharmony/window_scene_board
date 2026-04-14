/**
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


import { pageEditManager, PageEditViewModel } from '@ohos/launchercommon/Index';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { EditModeBlankPageViewParams, editModeViewManager } from '../manager/EditModeViewManager';
import { image } from '@kit.ImageKit';
import { EditModeConstants, EditModeUtils, PageInfoManager, editModeManager } from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';

const TAG: string = 'EditModeDragAnimatePage';

@Component
export default struct EditModeDragAnimatePage {
  private index: number = 0;
  private swiperKey = 0;
  private pageEditViewModel: PageEditViewModel = PageEditViewModel.getInstance();
  private isOuter: boolean = false;
  private bgSize: number | string = '100%';
  private componentHeight: number = this.pageEditViewModel.getScreenWidthOrHeight(false);
  private componentWidth: number = this.pageEditViewModel.getScreenWidthOrHeight(true);
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  private blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();
  @State dragSnapshots: image.PixelMap[] = pageEditManager.editModeDragAnimatePageData.dragSnapshot;
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();

  aboutToAppear(): void {
    this.blankPageViewParams = editModeViewManager.getBlankPageViewParams(this.isOuter);
    if (this.isOuter) {
      this.bgSize = EditModeUtils.getOuterBackgroundSize() * this.editModeStyleConfig.swiperEditScaleRate;
      this.componentHeight = this.bgSize;
      this.componentWidth = this.bgSize;
    } else {
      this.componentHeight = this.pageEditViewModel.getScreenWidthOrHeight(false);
      this.componentWidth = this.pageEditViewModel.getScreenWidthOrHeight(true);
    }
  }

  /**
   * 获取按钮背景颜色
   *
   * @returns 背景颜色
   */
  private getBgColor(): ResourceColor {
    // 主页高亮白色
    if (PageInfoManager.getInstance().isHomePage(this.index)) {
      return Color.White;
    }
    // 深色壁纸
    if (editModeViewManager.isDarkWallPaper()) {
      return $r('sys.color.ohos_id_color_background');
    }
    // 浅色壁纸
    return EditModeConstants.PAGE_EDIT_BUTTON_BG_COLOR;
  }

  /**
   * 获取按钮背景透明度
   *
   * @returns 透明度
   */
  private getBgOpacity(): number {
    // 主屏时按钮不透明
    if (PageInfoManager.getInstance().isHomePage(this.index)) {
      return 1;
    }
    // 深色壁纸
    if (editModeViewManager.isDarkWallPaper()) {
      return EditModeConstants.PAGE_EDIT_BUTTON_DEEP_BG_OPACITY;
    }
    // 浅色壁纸
    return 1;
  }

  @Builder
  dragPage() {
    Stack({ alignContent: Alignment.Top }) {
      Row()
        .width(this.bgSize)
        .height(this.bgSize)
        .backgroundColor(this.editModeStyleConfig.pageEditBgColor)
        .opacity(this.editModeSingePageViewData.getSingePageBackgroundOpacity())
        .borderRadius(this.pageEditViewModel.getSnapshotRadius(this.isOuter))
        .clip(true)

      if (PageInfoManager.getInstance().isHomePageSetSupport()) {
        // 设置主屏按钮
        Stack() {
          // 按钮背板
          Row() {
          }
          .width(`${EditModeConstants.HOME_PAGE_BUTTON_SIZE}vp`)
          .height(`${EditModeConstants.HOME_PAGE_BUTTON_SIZE}vp`)
          .borderRadius(this.blankPageViewParams.buttonBorderRadius)
          .backgroundColor(this.getBgColor())
          .opacity(this.getBgOpacity())
          // 按钮
          Text() {
            SymbolSpan(PageInfoManager.getInstance().isHomePage(this.index) ? $r('sys.symbol.house_fill') : $r('sys.symbol.house'))
              .fontSize(`${EditModeConstants.HOME_PAGE_BUTTON_SIZE / 2}vp`)
              .fontWeight(FontWeight.Normal)
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .fontColor([PageInfoManager.getInstance().isHomePage(this.index) ?
              $r('sys.color.ohos_id_color_emphasize') : Color.White])
          }
        }
        .translate({
          y: this.pageEditViewModel.getHomepageBtnYFromBgTop()
        })
      }

      if (this.pageEditViewModel.isCurrentPageBlank(this.swiperKey, this.isOuter)) {
        if (!PageInfoManager.getInstance().isHomePageSetSupport() ||
          !PageInfoManager.getInstance().isHomePage(this.index)) {
          Stack() {
            Row() {
            }
            .width(`${this.blankPageViewParams.buttonSize}vp`)
            .height(`${this.blankPageViewParams.buttonSize}vp`)
            .borderRadius(this.blankPageViewParams.buttonBorderRadius)
            .backgroundColor(
              editModeViewManager.isDarkWallPaper() ?
              this.editModeStyleConfig.pageEditButtonDarkBgColor :
              this.editModeStyleConfig.pageEditButtonBgColor
            )
            .opacity(editModeViewManager.isDarkWallPaper() ? this.editModeStyleConfig.pageEditButtonDeepBgOpacity : 1)

            Text() {
              SymbolSpan($r('sys.symbol.xmark'))
                .fontSize(`${this.blankPageViewParams.iconSize}vp`)
                .fontWeight(FontWeight.Normal)
                .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                .fontColor([Color.White])
            }
          }
          .translate({
            y: this.pageEditViewModel.getDeleteButtonYFromBgTop(this.isOuter)
          })
        }
      } else {
        Row({ space: PageEditViewModel.getInstance().getRowSpace() }) {
          ForEach(this.dragSnapshots, (snapshot: image.PixelMap) => {
            Image(snapshot)
              .width(pageEditManager.editModeDragAnimatePageData.imageSizeWidth * EditModeUtils.getDesktopScale() + 'px')
              .height(pageEditManager.editModeDragAnimatePageData.imageSizeHeight * EditModeUtils.getDesktopScale() + 'px')
              .objectFit(ImageFit.Contain)
              .draggable(false)
              .interpolation(ImageInterpolation.Medium)
              .translate({
                y: pageEditManager.editModeDragAnimatePageData.dragGridImageTopY -
                pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY
              })
          })
        }
      }
    }
    .width(this.componentWidth)
    .height(this.componentHeight)
    .scale({ x: EditModeConstants.PAGE_ZOOM_IN_SCALE, y: EditModeConstants.PAGE_ZOOM_IN_SCALE })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      this.dragPage();
    }
    .width(this.componentWidth * EditModeConstants.PAGE_ZOOM_IN_SCALE)
    .height(this.componentHeight * EditModeConstants.PAGE_ZOOM_IN_SCALE)
  }
}