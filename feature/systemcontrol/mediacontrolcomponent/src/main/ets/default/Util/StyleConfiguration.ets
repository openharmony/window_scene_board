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

import { default as CommonStyleManager } from '@ohos/systemuicommon/src/main/ets/manager/CommonStyleManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

const TAG = 'MediaControlCard-StyleConfiguration';

export class MediaControlCardLayoutStyle {
  public cardMediaLandscapeTitleWidth: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_landscape_title_width'));
  public cardMediaLandscapePicSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_landscape_pic_size'));
  public cardMediaLowerHalfHeight: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_lower_half_height'));
  public cardMediaPicSize: number = ResUtils.getConvertNumber($r('app.float.media_control_card_pic_size'));
  public cardMediaTitleHeight: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_title_height'));
  public cardMediaButtonSize: number = ResUtils.getConvertNumber($r('app.float.media_control_card_btn_size'));
  public cardMediaPlayButtonSize: number = ResUtils.getConvertNumber($r('app.float.media_control_play_btn_size'));
  public cardMediaRewindAndFastForwardButtonSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_rewind_fast_forward_btn_size'));
  public cardMediaButtonRight: number = ResUtils.getConvertNumber($r('app.float.media_control_btn_margin_right'));
  public cardMediaNoMusicPicSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_no_music_pic_size'));
  public cardMediaLandscapeLayoutBottomSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_landscape_margin_bottom_size'));
  public cardMediaIconSize: number = ResUtils.getConvertNumber($r('app.float.media_control_card_icon_size'));
  public cardMediaLayoutSize: number = ResUtils.getConvertNumber($r('app.float.media_control_card_margin_size'));
  public cardMediaLayoutBottomSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_margin_bottom_size'));
  public cardMediaLayoutTopSize: number =
    ResUtils.getConvertNumber($r('app.float.media_control_card_margin_top_size'));
  public cardMediaRadius: number = ResUtils.getConvertNumber($r('app.float.control_center_card_border_radius'));
  public cardMediaHotZone: number = ResUtils.getConvertNumber($r('app.float.control_center_title_space'));
}

export default class StyleConfiguration {
  static getMediaControlCardLayoutStyle(): MediaControlCardLayoutStyle {
    const key: string = TAG + '-MediaControlCardLayout';
    return CommonStyleManager.getStyle(key, MediaControlCardLayoutStyle);
  }
}