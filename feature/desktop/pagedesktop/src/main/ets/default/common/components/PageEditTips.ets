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

import lazy OuterEditConstants from "@ohos/desktopedit/src/main/ets/default/common/constants/OuterEditConstants";
import { GlobalContext, DeviceHelper } from "@ohos/frameworkwrapper";
import { CommonConstants, EditModeConstants, editModeManager } from "@ohos/launchercommon";
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import {
  EditModeDragAnimatePageData,
  EditModeDragPageTipTextData,
  pageEditManager,
  PageEditViewModel
} from "@ohos/launchercommon/Index";

/**
 * 编辑模式整屏拖拽提示语
 */
@Component
export default struct PageEditTips {
  private isOuterDesktop: boolean = false;
  @State editModeDragAnimatePageData: EditModeDragAnimatePageData = pageEditManager.editModeDragAnimatePageData;
  @State editModeDragPageTipTextData: EditModeDragPageTipTextData = pageEditManager.editModeDragPageTipTextData;
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  // 提示文本离背景板上边缘距离（小折叠内屏与通用设备不一致）
  private editModeDragPageTipBottomMargin = this.editModeStyleConfig.editModeDragPageTipBottomMargin;

  aboutToAppear(): void {
    GlobalContext.getContext()?.eventHub.on(CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
      this.onRemoveBtnShowEvent);
  }

  aboutToDisappear(): void {
    GlobalContext.getContext()?.eventHub.off(CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
      this.onRemoveBtnShowEvent);
  }

  private onRemoveBtnShowEvent: Function =
    (isShow: boolean, isDragCardItem: boolean): void => this.onRemoveBtnShow(isShow, isDragCardItem);

  /**
   * 编辑模式移除卸载按钮显示时，隐藏长按拖动页面提示语
   *
   * @param isShow
   * @param isDragCardItem
   */
  private onRemoveBtnShow(isShow: boolean, isDragCardItem: boolean): void {
    if (isShow) {
      PageEditViewModel.getInstance().dragPageTipShowOrHideAnimate(0);
    }
  }

  build() {
    Text($r('app.string.drag_page_tip'))
      .width('100%')
      .height(`${this.editModeStyleConfig.editModeDragPageTipHeight}vp`)
      .textAlign(TextAlign.Center)
      .fontWeight(this.editModeStyleConfig.dragPageTipTextFontWeight)
      .fontFamily('HarmonyHeiTi')
      .minFontSize('10vp')
      .maxFontSize(this.editModeStyleConfig.dragPageTipTextSize)
      .maxLines(EditModeConstants.EDIT_MODE_DRAG_PAGE_TIP_MAX_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
      .fontColor(this.editModeDragPageTipTextData.dragPageTipTextColor)
      .align(Alignment.Top)
      .margin({
        top: this.isOuterDesktop ? OuterEditConstants.DRAG_TIPS_TOP_MARGIN :
          this.editModeDragAnimatePageData.editModeBgTopPointY -
          this.editModeStyleConfig.editModeDragPageTipHeight -
          this.editModeDragPageTipBottomMargin,
      })
      .padding({
        left: EditModeConstants.EDIT_MODE_DRAG_PAGE_TIP_PADDING,
        right: EditModeConstants.EDIT_MODE_DRAG_PAGE_TIP_PADDING
      })
      .opacity(this.editModeDragPageTipTextData.dragPageTipTextOpacity)
      .accessibilityLevel(this.editModeDragPageTipTextData.dragPageTipTextOpacity ? 'yes' : 'no')
  }
}