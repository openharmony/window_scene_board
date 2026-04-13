/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import curves from '@ohos.curves';

/**
 * Constants of fold animation.
 */
export class FoldAnimationConstants {
  /**
   * expand animation delay
   */
  public static readonly EXPAND_DELAY: number = 200;

  /**
   * fold animation delay
   */
  public static readonly FOLD_DELAY: number = 100;

  /**
   * scaleX animation curves
   */
  public static readonly SCALE_CURVES = curves.interpolatingSpring(0, 1, 93.44, 17.40);

  /**
   * translateX animation curves
   */
  public static readonly TRANSLATE_CURVES = curves.springMotion(0.65, 0.9, 0);

  /**
   * translateX animation curves
   */
  public static readonly SYSTEM_TRANSLATE_CURVES = curves.springMotion(0.5, 0.95, 0);

  /**
   * alpha animation curves
   */
  public static readonly ALPHA_CURVES = curves.springMotion(0.4, 0.95, 0);

  /**
   * init fold property factor
   */
  public static readonly FOLD_FACTOR: number = -0.75;

  /**
   * init expand property factor
   */
  public static readonly EXPAND_FACTOR: number = -0.5;

  /**
   * status bar fold factor
   */
  public static readonly STATUS_FOLD_FACTOR = 0.75;

  /**
   * the width of dock background containing one item
   */
  public static readonly INIT_DOCK_BG_WIDTH: number = 76;

  /**
   * the difference between the widths of one item and two items about dock background
   */
  public static readonly DIFF_DOCK_BG_WIDTH: number = 84.768;

  /**
   * the difference between the scales of one item and two items about dock background
   */
  public static readonly DIFF_DOCK_BG_SCALE: number = 0.25;

  /**
   * the delay of dock background
   */
  public static readonly DOCK_BG_DELAY: number = 110;

  /**
   * the delay of recent background
   */
  public static readonly RECENT_BG_DELAY: number = 80;

  /**
   * animation Duration 100ms
   */
  public static readonly ANIMATION_DURATION_100: number = 100;

  /**
   * initial scale of animation
   */
  public static START_SCALE: number = 0.7;

  /**
   * statusBar alpha animation delay
   */
  public static BAR_ALPHA_DELAY: number = 150;

  /**
   * animation delay of edge col
   */
  public static DELAY_EDGE: number = 100;

  /**
   * animation delay of middle col
   */
  public static DELAY_MID: number = 0;

  /**
   * initial scale of dock divider
   */
  public static DIVIDER_SCALE: number = 0.5;

  /**
   * initial scale of dock backplane
   */
  public static BACKPLANE_SCALE: number = 0.5;

  /**
   * alpha delay of middle col
   */
  public static MIDDLE_DELAY: number = 116.7;

  /**
   * max column when expand
   */
  public static MAX_COLUMN: number = 8;

  /**
   * positive center column when expand
   */
  public static CENTER_COLUMN: number = 3.5;

  /**
   * initial translateX of middle when expand
   */
  public static TRANS_MID: number = 0.1;

  /**
   * initial translateX of edge when expand
   */
  public static TRANS_EDGE: number = 0.14;

  /**
   * initial translateX of middle when fold
   */
  public static FOLD_TRANS_MID: number = 0.16;

  /**
   * initial translateX of edge when fold
   */
  public static FOLD_TRANS_EDGE: number = 0.28;

  /**
   * animation duration of edge when expand
   */
  public static RESPONSE_EDGE: number = 0.46;

  /**
   * animation duration of middle when expand
   */
  public static RESPONSE_MID: number = 0.4;

  /**
   * initial translateX of indicator
   */
  public static INDICATOR_TRANS: number = 0.28;

  /**
   * column offset of type_folder
   */
  public static FOLDER_COL: number = 0.5;

  /**
   * column offset of large type_card
   */
  public static CARD_COL: number = 1.5;

  /**
   * Indicator alpha animate duration
   */
  public static INDICATOR_ALPHA_DURATION: number = 500;

  /**
   * Status Bar alpha animate duration
   */
  public static STATUS_BAR_ALPHA_DURATION: number = 450;

  /**
   * Icon item or Dock Background Alpha animate duration
   */
  public static ICON_OR_DOCK_ALPHA_DURATION: number = 300;

  /**
   * row offset of type_folder
   */
  public static FOLDER_ROW_OFFSET: number = 0.5;

  /**
   * row offset of 4*4 type_card
   */
  public static CARD_ROW_OFFSET: number = 1.5;

  /**
   * indicator row in small fold product
   */
  public static INDICATOR_ROW: number = 4.5;

  /**
   * dock row in small fold product
   */
  public static DOCK_ROW: number = 5;

  /**
   * max row in small fold product when expand
   */
  public static MAX_ROW: number = 6;

  /**
   * inital translateY factor of middle row in small fold product
   */
  public static TRANS_MID_FACTOR: number = 0.1;

  /**
   * inital translateY factor of edge row in small fold product
   */
  public static TRANS_EDGE_FACTOR: number = 0.14;

  /**
   * first param of curve in middle row when expand in small fold product
   */
  public static RESPONSE_MID_SMALL_FOLD: number = 0.35;

  /**
   * first param of curve in edge row when expand in small fold product
   */
  public static RESPONSE_EDGE_SMALL_FOLD: number = 0.4;

  /**
   *  alpha delay of middle row in small fold product
   */
  public static MIDDLE_ROW_DELAY: number = 66;

  /**
   * item alpha animation duration in small fold product
   */
  public static ITEM_ALPHA_DURATION: number = 300;

  /**
   * initial value for quick opening and closing scenarios
   */
  public static INITIAL_VALUE: number = 0.01;

  /**
   * Sharp-CubicBezier Curve
   */
  public static SHARP_BEZIER_CURVE: ICurve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

  /**
   * item scale animation curve
   */
  public static SCALE_CURVE: ICurve = curves.springMotion(0.4, 1, 0);

  /**
   * indicator fold animation curve
   */
  public static INDICATOR_CURVE: ICurve = curves.springMotion(0.6, 1, 0);

  /**
   * item fold animation curve
   */
  public static ITEM_FOLD_CURVE: ICurve = curves.springMotion(0.5, 1, 0);
}