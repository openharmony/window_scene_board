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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import { FormZoomUtil } from '../common/FormZoomUtil';
import { CheckZoomResult, ZoomHotArea, ZoomOffset, ZoomType } from '../common/FormZoomCommonType';
import { FormZoomEvent } from '../viewModel/FormZoomEvent';
import { FormZoomManager } from '../common/FormZoomManager';
import { ZoomBarVisible } from '../viewModel/FormZoomVm';
import { NORMAL_CARD_ALIGN_DEFAULT_MAP, THEME_CARD_ALIGN_DEFAULT_MAP } from '../common/FormZoomConstants';

const TAG = 'FormZoomHotAreaComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 拖拽热区
 */
@Component
export struct FormZoomHotAreaComponent {
  @Prop mHotArea: ZoomHotArea = FormZoomUtil.AREA_NONE;
  @Link barVisible: ZoomBarVisible;
  @Link inDrag: boolean;
  @Consume mFormZoomEvent: FormZoomEvent;
  private gestureStarted: boolean = false;
  private currentZoomResult?: CheckZoomResult;

  build() {
    Column() {
    }
    .width(this.mHotArea.width)
    .height(this.mHotArea.height)
    .offset({ x: this.mHotArea.offsetX, y: this.mHotArea.offsetY })
    .hitTestBehavior(HitTestMode.Block)
    .gesture(
      PanGesture(new PanGestureOptions({ fingers: 1, distance: 0, direction: PanDirection.All }))
        .onActionUpdate((event?: GestureEvent) => {
          if (!this.gestureStarted) {
            log.showWarn('onGestureUpdate gesture has ended');
            return;
          }
          if (!event) {
            log.showError('gesture event is undefined');
            return;
          }
          if (!this.mFormZoomEvent) {
            log.showError('FormZoomEvent is undefined');
            return;
          }
          let zoomType: ZoomType = FormZoomUtil.getZoomType(this.mHotArea.position, event.offsetX, event.offsetY);
          let zoomOffset: ZoomOffset = FormZoomUtil.getOffset(this.mHotArea.position, event.offsetX, event.offsetY);
          let cardItem: CardItemInfo = this.mFormZoomEvent.getFormItem();
          let result: CheckZoomResult = FormZoomUtil.checkZoom(this.mHotArea.position,
            zoomType, cardItem);
          let defaultAlignContent: Alignment = cardItem.bundleName === CommonConstants.THEME_MANAGER_BUNDLE ?
            THEME_CARD_ALIGN_DEFAULT_MAP.get(this.mHotArea.position) as Alignment :
            NORMAL_CARD_ALIGN_DEFAULT_MAP.get(this.mHotArea.position) as Alignment;
          this.currentZoomResult = result;
          this.mFormZoomEvent.onDragZoomMove(this.currentZoomResult, zoomOffset, defaultAlignContent);
        })
    )
    .onTouch((event?: TouchEvent) => {
      if (event?.type === CommonConstants.TOUCH_TYPE_DOWN) {
        if (FormZoomManager.getInstance().isFormZoomLocked()) {
          log.showInfo('form zoom locked');
          return;
        }
        if (this.gestureStarted) {
          log.showInfo('form zoom not end');
          return;
        }
        FormZoomManager.getInstance().setFormZoomLocked(true);
        this.inDrag = true;
        let formZoomId: string | undefined = AppStorage.get('formZoomId');
        if (formZoomId && formZoomId !== '-1' && this.mFormZoomEvent) {
          this.barVisible = new ZoomBarVisible(
            this.mHotArea.offsetX === '-50%',
            this.mHotArea.offsetY === '-50%',
            this.mHotArea.offsetX === '50%',
            this.mHotArea.offsetY === '50%',
          );
          FormZoomManager.getInstance().setFormZoomSnapshot(formZoomId, undefined);
        }
        this.gestureStarted = true;
      }
      if (event?.type === CommonConstants.TOUCH_TYPE_UP) {
        this.barVisible = new ZoomBarVisible(true, true, true, true);
        FormZoomManager.getInstance().setFormZoomLocked(false);
        let formZoomId: string | undefined = AppStorage.get('formZoomId');
        if (formZoomId && formZoomId !== '-1' && this.mFormZoomEvent) {
          this.mFormZoomEvent.onDragZoomEnd();
        }
        this.gestureStarted = false;
      }
    })
  }
}