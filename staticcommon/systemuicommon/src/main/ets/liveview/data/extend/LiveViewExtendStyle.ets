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
import { ExtendStyle } from '../../common/Extendstyle';

export class LiveViewExtendStyle implements ExtendStyle {
  /**
   * 三方辅助区宽高
   */
  public extendWidth: number = 44;
  public extendHeight: number = 44;

  /**
   * 导航辅助区宽高
   */
  public navExtendWidth: number = 56;
  public navExtendHeight: number = 36;

  /**
   * 普通文本参数
   */
  public normalTextWidth: number = 30;
  public normalTextHeight: number = 28;
  public normalTextMaxFont: number = 14;
  public normalTextMinFont: number = 10;
  public textColor: Resource = $r('sys.color.ohos_id_color_text_primary');

  /**
   * 胶囊文本参数
   */
  public capsuleButtonHeight: number = 24;
  public capsuleButtonWidth : Length = 44;
  public capsuleButtonMaxWidth : Length = 70;
  public capsuleButtonTextHeight: number = 20;
  public capsuleButtonTopMargin: number = 2;
  public capsuleButtonLeftMargin: number = 8;
  public capsuleBackgroundColor?: ResourceColor = $r('app.color.live_card_extend_button_bg');
  /**
   * 系统按钮宽度
   */
  public buttonSpace: number = 12;
  public buttonHeight: number = 40;
  public buttonLength: number = 40;
  public buttonBorderRadius: number = 20;
  public buttonBackground: ResourceColor = '#FF000000';
  public deliverLiveButtonBackground: ResourceColor = '#0D000000';
  /**
   * 进度按钮参数
   */
  public progressHeight: number = 40;
  public progressWidth: number = 40;
  public progressStrokeWidth: number = 6;
  public progressBackgroundColor: ResourceColor = '#19182431';
  public progressColor: ResourceColor = '#0A59F7';

}