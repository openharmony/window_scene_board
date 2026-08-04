/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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
 * Constants of triple fold product's animation.
 */
export class TripleFoldAnimationConstants {

  /**
   * translateX animation curves
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_DEFAULT = Curve.Linear;

  /**
   * translateX animation curves when state changed from F to M
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_F2M = curves.springMotion(0.5, 0.95, 0);

  /**
   * translateX animation curves when state changed from M to F
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_M2F = curves.springMotion(0.5, 0.95, 0);

  /**
   * translateX animation curves when state changed from F to G
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_F2G = curves.springMotion(0.6, 0.95, 0);

  /**
   * translateX animation curves when state changed from M to G
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_M2G = curves.springMotion(0.5, 0.95, 0);

  /**
   * translateX animation curves when state changed from G to M
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_G2M = curves.springMotion(0.5, 0.95, 0);

  /**
   * translateX animation curves when state changed from G to F
   */
  public static readonly SYSTEM_TRANSLATE_CURVES_G2F = curves.springMotion(0.5, 0.95, 0);

  /**
   * alpha animation curves
   */
  public static readonly ALPHA_CURVES_DEFAULT = Curve.Linear;

  /**
   * alpha animation curves of scene panel when state changed from F to M
   */
  public static readonly ALPHA_CURVES_F2M = curves.springMotion(0.4, 0.95, 0);

  /**
   * alpha animation curves of scene panel when state changed from M to F
   */
  public static readonly ALPHA_CURVES_M2F = curves.springMotion(0.4, 0.95, 0);

  /**
   * alpha animation curves of scene panel when state changed from F to G
   */
  public static readonly ALPHA_CURVES_F2G = curves.springMotion(0.25, 0.95, 0);

  /**
   * alpha animation curves of scene panel when state changed from G to F
   */
  public static readonly ALPHA_CURVES_G2F = curves.springMotion(0.25, 0.95, 0);

  /**
   * alpha animation curves of scene panel when state changed from M to G
   */
  public static readonly ALPHA_CURVES_M2G = curves.springMotion(0.4, 1, 0);

  /**
   * alpha animation curves of scene panel when state changed from G to M
   */
  public static readonly ALPHA_CURVES_G2M = curves.springMotion(0.4, 1, 0);

  /**
   * alpha animation curves of snapshot
   */
  public static readonly ALPHA_SNAPSHOT_CURVES_DEFAULT = Curve.Linear;

  /**
   * alpha animation curves of snapshot when state changed from F to G
   */
  public static readonly ALPHA_SNAPSHOT_CURVES_F2G = curves.springMotion(0.5, 1, 0);

  /**
   * alpha animation curves of snapshot when state changed from G to F
   */
  public static readonly ALPHA_SNAPSHOT_CURVES_G2F = curves.springMotion(0.5, 1, 0);

  /**
   * alpha animation curves of snapshot when state changed from M to G
   */
  public static readonly ALPHA_SNAPSHOT_CURVES_M2G = curves.springMotion(0.25, 1, 0);

  /**
   * alpha animation curves of snapshot when state changed from G to M
   */
  public static readonly ALPHA_SNAPSHOT_CURVES_G2M = curves.springMotion(0.25, 1, 0);

  /**
   * init F to M property factor
   */
  public static readonly F2M_FACTOR: number = -0.5;

  /**
   * init M to F property factor
   */
  public static readonly M2F_FACTOR: number = 0.75;

  /**
   * init M to G property factor
   */
  public static readonly M2G_FACTOR: number = 0.357;

  /**
   * init G to M property factor
   */
  public static readonly G2M_FACTOR: number = -0.545;

  /**
   * init F to G property factor
   */
  public static readonly F2G_FACTOR: number = -0.66;

  /**
   * init G to F property factor
   */
  public static readonly G2F_FACTOR: number = 1;

  /**
   * the page number in triple fold product when M state
   **/
  public static PAGES_M: number = 2;

  // the page number in triple fold product when G state
  public static PAGES_G: number = 3;

  /**
   * the max columns in triple fold product
   **/
  public static MAX_COLUMN: number = 8;

  // the max columns in triple fold product
  public static THREE_DISPLAY_COLUMN: number = 12;

  /**
   * the max columns of one page
   **/
  public static MAX_PAGE_COLUMN: number = 4;

  /**
   * the column of indicator in triple fold product when F state
   **/
  public static INDICATOR_COLUMN_F: number = 1.5;

  /**
   * the column of indicator in triple fold product when M or G state
   **/
  public static INDICATOR_COLUMN_MG: number = 3.5;

  /**
   * item translateX factor when F To M
   */
  public static ITEM_TRANS_FTM: number = -0.5;

  /**
   * item translateX factor when M To F
   */
  public static ITEM_TRANS_MTF: number = 0.75;

  /**
   * item translateX factor when M To G
   */
  public static ITEM_TRANS_MTG: number = 1 / 6;

  /**
   * item translateX factor when G To M
   */
  public static ITEM_TRANS_GTM: number = -0.25;

  /**
   * item translateX factor when F To G
   */
  public static ITEM_TRANS_FTG: number = -1 / 3;

  /**
   * item translateX factor when G To F
   */
  public static ITEM_TRANS_GTF: number = 1;

  /**
   * F-TO-M cubic-bezier curve param of left item
   */
  public static FTM_CURVES_PARAM_LEFT: number = 0.1;

  /**
   * F-TO-M cubic-bezier curve param of right item
   */
  public static FTM_CURVES_PARAM_RIGHT: number = 0.4;

  /**
   * M-TO-F cubic-bezier curve param of left item
   */
  public static MTF_CURVES_PARAM_LEFT: number = 0.3;

  /**
   * M-TO-F cubic-bezier curve param of right item
   */
  public static MTF_CURVES_PARAM_RIGHT: number = 0.15;

  /**
   * M-TO-G cubic-bezier curve param of left item
   */
  public static MTG_CURVES_PARAM_LEFT: number = 0.4;

  /**
   * M-TO-G cubic-bezier curve param of right item
   */
  public static MTG_CURVES_PARAM_RIGHT: number = 0.1;

  /**
   * G-TO-M cubic-bezier curve param of left item
   */
  public static GTM_CURVES_PARAM_LEFT: number = 0.1;

  /**
   * G-TO-M cubic-bezier curve param of right item
   */
  public static GTM_CURVES_PARAM_RIGHT: number = 0.4;

  /**
   * F-TO-G cubic-bezier curve param of left item
   */
  public static FTG_CURVES_PARAM_LEFT: number = 0.1;

  /**
   * F-TO-G cubic-bezier curve param of right item
   */
  public static FTG_CURVES_PARAM_RIGHT: number = 0.4;

  /**
   * G-TO-F cubic-bezier curve param of left item
   */
  public static GTF_CURVES_PARAM_LEFT: number = 0.4;

  /**
   * G-TO-F cubic-bezier curve param of right item
   */
  public static GTF_CURVES_PARAM_RIGHT: number = 0.1;

  /**
   * the first ordinate in cubic-bezier curve
   */
  public static ITEM_CURVES_PARAM_Y_FIRST: number = 0.4;

  /**
   * the second ordinate in cubic-bezier curve
   */
  public static ITEM_CURVES_PARAM_Y_SECOND: number = 1;

  /**
   * the alpha animation delay is 0
   */
  public static ALPHA_DELAY_ZERO: number = 0;

  /**
   * the alpha animation delay is 100
   */
  public static ALPHA_DELAY_ONE_HUNDRED: number = 100;

  /**
   * the alpha animation delay is 200
   */
  public static ALPHA_DELAY_TWO_HUNDRED: number = 200;

  /**
   * the alpha animation duration is 200
   */
  public static ALPHA_DURATION: number = 250;

  /**
   * the duration of dock background alpha animation
   */
  public static readonly DOCK_BG_ALPHA_DURATION: number = 300;

  /**
   * the duration of swiper page translate animation
   */
  public static readonly ANIMATION_DURATION: number = 600;

  /**
   * the duration of swiper page animation for short translation, for example: 345 - 45
   */
  public static readonly SHORT_ANIMATION_DURATION: number = 500;

  /**
   * the duration of swiper page animation for GTF when the language is RTL language
   */
  public static readonly LONG_ANIMATION_DURATION: number = 800;

  /**
   * translateX animation curves when device is three fold product
   */
  public static readonly TRANSLATE_CURVES = curves.cubicBezierCurve(0.25, 0.1, 0.25, 1);

  /**
   * translateX animation curves of right side not actually displayed page
   */
  public static readonly CURVES_RIGHT_MARGINAL = curves.cubicBezierCurve(0.2, 0.1, 0.3, 1);

  /**
   * translateX animation curves of left side not actually displayed page
   */
  public static readonly CURVES_LEFT_MARGINAL = curves.cubicBezierCurve(0.2, 0.1, 0.15, 1);

  /**
   * M-TO-G cubic-bezier curve param of left item for three display
   */
  public static THREE_DISPLAY_MTG_CURVES_LEFT: number = 0.3;

  /**
   * M-TO-G cubic-bezier curve param of right item for three display
   */
  public static THREE_DISPLAY_MTG_CURVES_RIGHT: number = 0.15;

  /**
   * G-TO-M cubic-bezier curve param of left item for three display
   */
  public static THREE_DISPLAY_GTM_CURVES_LEFT: number = 0.15;

  /**
   * G-TO-M cubic-bezier curve param of right item for three display
   */
  public static THREE_DISPLAY_GTM_CURVES_RIGHT: number = 0.3;

  /**
   * status bar translate animation duration
   */
  public static readonly STATUS_BAR_TRANSLATE_DURATION = 600;
}