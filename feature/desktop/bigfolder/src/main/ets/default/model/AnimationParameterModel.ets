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

import { AnimateExCallback } from '@ohos/windowscene/Index';
import { curves } from '@kit.ArkUI';
import { SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG: string = 'AnimationParameterModel';

// 打开关闭小文件夹时图标的秩序感动效名称
const OPEN_SMALL_FOLDER_ANIS: string[] = [
  'smallFolderToOpenFolderIcon',
  'smallFolderToOpenFolderIcon1',
  'smallFolderToOpenFolderIcon2',
  'smallFolderToOpenFolderIcon3',
  'smallFolderToOpenFolderIcon4',
  'smallFolderToOpenFolderIcon5',
];
const CLOSE_SMALL_FOLDER_ANIS: string[] = [
  'OpenFolderToSmallFolderIcon',
  'OpenFolderToSmallFolderIcon1',
  'OpenFolderToSmallFolderIcon2',
  'OpenFolderToSmallFolderIcon3',
  'OpenFolderToSmallFolderIcon4',
  'OpenFolderToSmallFolderIcon5',
];

// 打开关闭大文件夹时图标的秩序感动效名称
const OPEN_BIG_FOLDER_ANIS: string[] = [
  'bigFolderToOpenFolderIcon',
  'bigFolderToOpenFolderIcon1',
  'bigFolderToOpenFolderIcon2',
  'bigFolderToOpenFolderIcon3',
  'bigFolderToOpenFolderIcon4',
  'bigFolderToOpenFolderIcon5',
];
const CLOSE_BIG_FOLDER_ANIS: string[] = [
  'OpenFolderToBigFolderIcon',
  'OpenFolderToBigFolderIcon1',
  'OpenFolderToBigFolderIcon2',
  'OpenFolderToBigFolderIcon3',
  'OpenFolderToBigFolderIcon4',
  'OpenFolderToBigFolderIcon5',
];

// 打开大文件夹时图标名称的秩序感动效名称
const OPEN_BIG_FOLDER_ICON_NAME_ANIS: string[] = [
  'bigFolderToOpenFolderBT',
  'bigFolderToOpenFolderBT1',
  'bigFolderToOpenFolderBT2',
  'bigFolderToOpenFolderBT3',
  'bigFolderToOpenFolderBT4',
  'bigFolderToOpenFolderBT5',
];

// 打开关闭大文件夹时图标透明度的秩序感动效名称
const OPEN_BIG_FOLDER_ICON_OPT_ANIS: string[] = [
  'bigFolderToOpenFolderOpt',
  'bigFolderToOpenFolderOpt1',
  'bigFolderToOpenFolderOpt2',
  'bigFolderToOpenFolderOpt3',
  'bigFolderToOpenFolderOpt4',
  'bigFolderToOpenFolderOpt5',
];
const CLOSE_BIG_FOLDER_ICON_OPT_ANIS: string[] = [
  'OpenFolderToBigFolderOpt',
  'OpenFolderToBigFolderOpt1',
  'OpenFolderToBigFolderOpt2',
  'OpenFolderToBigFolderOpt3',
  'OpenFolderToBigFolderOpt4',
  'OpenFolderToBigFolderOpt5',
];

// 打开关闭小文件夹时图标透明度的秩序感动效名称
const OPEN_SMALL_FOLDER_ICON_OPT_ANIS: string[] = [
  'smallFolderToOpenFolderOpt',
  'smallFolderToOpenFolderOpt1',
  'smallFolderToOpenFolderOpt2',
  'smallFolderToOpenFolderOpt3',
  'smallFolderToOpenFolderOpt4',
  'smallFolderToOpenFolderOpt5',
];
const CLOSE_SMALL_FOLDER_ICON_OPT_ANIS: string[] = [
  'OpenFolderToSmallFolderOpt',
  'OpenFolderToSmallFolderOpt1',
  'OpenFolderToSmallFolderOpt2',
  'OpenFolderToSmallFolderOpt3',
  'OpenFolderToSmallFolderOpt4',
  'OpenFolderToSmallFolderOpt5',
];

// 打开4x2大文件夹时图标名称的秩序感动效名称
const OPEN_4x2_BIG_FOLDER_ICON_NAME_ANIS: string[] = [
  '4x2bigFolderToOpenFolderBT',
  '4x2bigFolderToOpenFolderBT1',
  '4x2bigFolderToOpenFolderBT2',
  '4x2bigFolderToOpenFolderBT3',
];

/**
 * 文件夹打开关闭动效集合，包含图标底部动效，背板动效，图标缩放位移动效，文件夹展开态标题动效
 */
export class OpenCloseAnimator {
  public bottomTextParam?: AnimatorParameter;
  public backgroundParam?: AnimatorParameter;
  // 图标的位移缩放动效
  public iconParam?: AnimatorParameter;
  public titleParam?: AnimatorParameter;
  // 用于展开态图标与折叠态图标数量不一致时，多出图标的显隐动效
  public iconOptParam?: AnimatorParameter;
}

/**
 * 具体动效类，包含动效名称，动效参数，动效处理，结束回调，通过index完成指定关系
 */
export class AnimatorParameter {
  // 动效唯一标识符,用于标识哪个动效
  private _animatorNames: string[] = [];
  private _params: AnimateParam[] = [];
  private _eventArray: Array<AnimateExCallback[]> = [];
  private _finishArray: Array<AnimateExCallback[]> = [];

  public set animatorNames(value: string[]) {
    this._animatorNames = value;
  }

  public get animatorNames(): string[] {
    return this._animatorNames;
  }

  public set params(value: AnimateParam[]) {
    this._params = value;
  }

  public get params(): AnimateParam[] {
    return this._params;
  }

  public get eventArray(): Array<AnimateExCallback[]> {
    return this._eventArray;
  }

  public get finishArray(): Array<AnimateExCallback[]> {
    return this._finishArray;
  }
}

/**
 * 文件夹类型
 */
export enum FolderType {
  TYPE_SMALL_FOLDER = 0x0,
  TYPE_NORMAL_BIG_FOLDER = 0x1,
  TYPE_1X2_BIG_FOLDER = 0x2,
  TYPE_2X1_BIG_FOLDER = 0x3,
  TYPE_4X2_BIG_FOLDER = 0x4,

  // 小文件夹无秩序感
  TYPE_SMALL_FOLDER_NO_SEQUENCES = 0x5,

  // 大文件夹无秩序感
  TYPE_BIG_FOLDER_NO_SEQUENCES = 0x6,

  TYPE_3X4_OPEN_FOLDER = 0x00,
  TYPE_4X4_OPEN_FOLDER = 0x10,
}

export class AnimationParameterModel {
  // 无秩序感的大文件夹动效集合
  private openNormalBigFolderNoSequencesAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private closeNormalBigFolderNoSequencesAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  // 有秩序感的小文件夹至3x4展开态动效集合
  private openSmallFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private closeSmallFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  // 有秩序感的小文件夹至4x4展开态动效集合
  private openSmallFolderTo4x4Animator: OpenCloseAnimator = new OpenCloseAnimator();
  private closSmallFolderTo4x4Animator: OpenCloseAnimator = new OpenCloseAnimator();
  // 无秩序感的小文件夹动效集合
  private openSmallFolderNoSequencesAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private closeSmallFolderNoSequencesAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  // 有秩序感的大文件夹动效集合
  private openBigFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private closeBigFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  // 有秩序感的4x2大文件夹动效集合
  private open4x2BigFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private close4x2BigFolderAnimator: OpenCloseAnimator = new OpenCloseAnimator();
  private openCloseFolderAnimatorMap: Map<number, OpenCloseAnimator[]> = new Map();

  constructor() {
    this.initNormalBigFolderAnimator();
    this.initSmallFolderAnimator(true);
    this.initSmallFolderAnimator(false);
    this.initSmallFolderNoOrderlyAnimator();
    this.initBigFolderAnimator();
    this.init4x2BigFolderAnimator();

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_SMALL_FOLDER,
      [this.openSmallFolderAnimator, this.closeSmallFolderAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_4X4_OPEN_FOLDER | FolderType.TYPE_SMALL_FOLDER,
      [this.openSmallFolderTo4x4Animator, this.closSmallFolderTo4x4Animator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_SMALL_FOLDER_NO_SEQUENCES,
      [this.openSmallFolderNoSequencesAnimator, this.closeSmallFolderNoSequencesAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_4X4_OPEN_FOLDER | FolderType.TYPE_SMALL_FOLDER_NO_SEQUENCES,
      [this.openSmallFolderNoSequencesAnimator, this.closeSmallFolderNoSequencesAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_BIG_FOLDER_NO_SEQUENCES,
      [this.openNormalBigFolderNoSequencesAnimator, this.closeNormalBigFolderNoSequencesAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_4X4_OPEN_FOLDER | FolderType.TYPE_NORMAL_BIG_FOLDER,
      [this.openNormalBigFolderNoSequencesAnimator, this.closeNormalBigFolderNoSequencesAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_NORMAL_BIG_FOLDER,
      [this.openBigFolderAnimator, this.closeBigFolderAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_1X2_BIG_FOLDER,
      [this.openBigFolderAnimator, this.closeBigFolderAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_2X1_BIG_FOLDER,
      [this.openBigFolderAnimator, this.closeBigFolderAnimator]);

    this.openCloseFolderAnimatorMap.set(
      FolderType.TYPE_3X4_OPEN_FOLDER | FolderType.TYPE_4X2_BIG_FOLDER,
      [this.open4x2BigFolderAnimator, this.close4x2BigFolderAnimator]);
  }

  public findAnimators(type: number): OpenCloseAnimator[] {
    let animators: OpenCloseAnimator[] | undefined = this.openCloseFolderAnimatorMap.get(type);
    if (animators) {
      return animators;
    }
    return [];
  }

  private initNormalBigFolderAnimator(): void {
    let openBottomTextParam: AnimatorParameter = new AnimatorParameter();
    openBottomTextParam.animatorNames = ['2x2BigFolderToOpenFolderBT'];
    openBottomTextParam.params = [
      {
        duration: 250,
        delay: 200,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(openBottomTextParam);
    this.initFinishArray(openBottomTextParam)
    this.openNormalBigFolderNoSequencesAnimator.bottomTextParam = openBottomTextParam;

    let openBackgroundParam: AnimatorParameter = new AnimatorParameter();
    openBackgroundParam.animatorNames = ['2x2BigFolderToOpenFolderBG'];
    openBackgroundParam.params = [
      {
        duration: 200,
        curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
      }
    ];
    this.initEventArray(openBackgroundParam);
    this.initFinishArray(openBackgroundParam)
    this.openNormalBigFolderNoSequencesAnimator.backgroundParam = openBackgroundParam;

    let openIconParam: AnimatorParameter = new AnimatorParameter();
    openIconParam.animatorNames = ['2x2BigFolderToOpenFolderIcon'];
    openIconParam.params = [
      {
        duration: 350,
        curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
      }
    ];
    this.initEventArray(openIconParam);
    this.initFinishArray(openIconParam)
    this.openNormalBigFolderNoSequencesAnimator.iconParam = openIconParam;

    let openHiddenIconParam: AnimatorParameter = new AnimatorParameter();
    openHiddenIconParam.animatorNames = ['2x2BigFolderToOpenFolderHiddenIcon'];
    openHiddenIconParam.params = [
      {
        duration: 100,
        curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
      }
    ];
    this.initEventArray(openHiddenIconParam);
    this.initFinishArray(openHiddenIconParam)
    this.openNormalBigFolderNoSequencesAnimator.iconOptParam = openHiddenIconParam;

    let openTitleParam: AnimatorParameter = new AnimatorParameter();
    openTitleParam.animatorNames = ['2x2BigFolderToOpenFolderTitle'];
    openTitleParam.params = [
      {
        duration: 100,
        delay: 200,
      }
    ];
    this.initEventArray(openTitleParam);
    this.initFinishArray(openTitleParam)
    this.openNormalBigFolderNoSequencesAnimator.titleParam = openTitleParam;

    let closeBottomTextParam: AnimatorParameter = new AnimatorParameter();
    closeBottomTextParam.animatorNames = ['OpenFolderTo2x2BigOpenFolderBT'];
    closeBottomTextParam.params = [
      {
        duration: 90,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeBottomTextParam);
    this.initFinishArray(closeBottomTextParam)
    this.closeNormalBigFolderNoSequencesAnimator.bottomTextParam = closeBottomTextParam;

    let closeBackgroundParam: AnimatorParameter = new AnimatorParameter();
    closeBackgroundParam.animatorNames = ['OpenFolderTo2x2BigOpenFolderBG'];
    closeBackgroundParam.params = [
      {
        duration: 500,
        curve: curves.cubicBezierCurve(0.2, 0, 0, 1)
      }
    ];
    this.initEventArray(closeBackgroundParam);
    this.initFinishArray(closeBackgroundParam)
    this.closeNormalBigFolderNoSequencesAnimator.backgroundParam = closeBackgroundParam;

    let closeIconParam: AnimatorParameter = new AnimatorParameter();
    closeIconParam.animatorNames = ['OpenFolderTo2x2BigOpenFolderIcon'];
    closeIconParam.params = [
      {
        duration: 500,
        curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
      }
    ];
    this.initEventArray(closeIconParam);
    this.initFinishArray(closeIconParam)
    this.closeNormalBigFolderNoSequencesAnimator.iconParam = closeIconParam;

    let closeHiddenIconParam: AnimatorParameter = new AnimatorParameter();
    closeHiddenIconParam.animatorNames = ['OpenFolderTo4x2BigFolderHiddenIcon'];
    closeHiddenIconParam.params = [
      {
        duration: 100,
        delay: 150,
        curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
      }
    ];
    this.initEventArray(closeHiddenIconParam);
    this.initFinishArray(closeHiddenIconParam)
    this.closeNormalBigFolderNoSequencesAnimator.iconOptParam = closeHiddenIconParam;

    let closeTitleParam: AnimatorParameter = new AnimatorParameter();
    closeTitleParam.animatorNames = ['OpenFolderTo2x2BigOpenFolderTitle'];
    closeTitleParam.params = [
      {
        duration: 100,
      }
    ];
    this.initEventArray(closeTitleParam);
    this.initFinishArray(closeTitleParam)
    this.closeNormalBigFolderNoSequencesAnimator.titleParam = closeTitleParam;
  }

  private initSmallFolderAnimator(is4x4: boolean): void {
    let curve: ICurve = is4x4 ?
    curves.interpolatingSpring(0, 1, 247, 30) : curves.interpolatingSpring(0, 1, 362.5, 33.9);
    let openBottomTextParam: AnimatorParameter = new AnimatorParameter();
    openBottomTextParam.animatorNames = ['smallFolderToOpenFolderBT'];
    openBottomTextParam.params = [
      {
        duration: 150,
        delay: 150,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(openBottomTextParam);
    this.initFinishArray(openBottomTextParam);

    let openBackgroundParam: AnimatorParameter = new AnimatorParameter();
    openBackgroundParam.animatorNames = ['smallFolderToOpenFolderBG', 'smallFolderToOpenFolderBGTrans'];
    openBackgroundParam.params.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    openBackgroundParam.params.push({
      curve: curve,
      delay: DeviceHelper.isPad() ? 50 : 0, // pad背板没有包住图标， UX定制
    });
    this.initEventArray(openBackgroundParam);
    this.initFinishArray(openBackgroundParam);

    let openIconParam: AnimatorParameter = new AnimatorParameter();
    openIconParam.animatorNames = OPEN_SMALL_FOLDER_ANIS;
    for (let i = 0; i < OPEN_SMALL_FOLDER_ANIS.length; i++) {
      openIconParam.params.push({
        delay: 16.67 * i,
        curve: curve,
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    this.initEventArray(openIconParam);
    this.initFinishArray(openIconParam);

    let openTitleParam: AnimatorParameter = new AnimatorParameter();
    openTitleParam.animatorNames = ['smallFolderToOpenFolderTitle'];
    openTitleParam.params = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    this.initEventArray(openTitleParam);
    this.initFinishArray(openTitleParam);

    let openIconOptParam: AnimatorParameter = new AnimatorParameter();
    openIconOptParam.animatorNames = OPEN_SMALL_FOLDER_ICON_OPT_ANIS;
    for (let i = 0; i < OPEN_SMALL_FOLDER_ICON_OPT_ANIS.length; i++) {
      openIconOptParam.params.push({
        duration: 250,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    this.initEventArray(openIconOptParam);
    this.initFinishArray(openIconOptParam);

    let closeBottomTextParam: AnimatorParameter = new AnimatorParameter();
    closeBottomTextParam.animatorNames = ['OpenFolderToSmallFolderBT'];
    closeBottomTextParam.params = [
      {
        duration: 100,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeBottomTextParam);
    this.initFinishArray(closeBottomTextParam);

    let closeBackgroundParam: AnimatorParameter = new AnimatorParameter();
    closeBackgroundParam.animatorNames = ['OpenFolderToSmallFolderBG', 'OpenFolderToSmallFolderBGTrans'];
    closeBackgroundParam.params.push({
      duration: 250,
      delay: 100,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    closeBackgroundParam.params.push({
      duration: 350,
      delay: 50,
      curve: curve,
    });
    this.initEventArray(closeBackgroundParam);
    this.initFinishArray(closeBackgroundParam);

    let closeIconParam: AnimatorParameter = new AnimatorParameter();
    closeIconParam.animatorNames = CLOSE_SMALL_FOLDER_ANIS;
    for (let i = 0; i < CLOSE_SMALL_FOLDER_ANIS.length; i++) {
      closeIconParam.params.push({
        delay: 16.67 * i,
        curve: curve,
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    this.initEventArray(closeIconParam);
    this.initFinishArray(closeIconParam);

    let closeTitleParam: AnimatorParameter = new AnimatorParameter();
    closeTitleParam.animatorNames = ['OpenFolderToSmallFolderTitle'];
    closeTitleParam.params = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeTitleParam);
    this.initFinishArray(closeTitleParam);

    let closeIconOptParam: AnimatorParameter = new AnimatorParameter();
    closeIconOptParam.animatorNames = CLOSE_SMALL_FOLDER_ICON_OPT_ANIS;
    for (let i = 0; i < CLOSE_SMALL_FOLDER_ICON_OPT_ANIS.length; i++) {
      closeIconOptParam.params.push({
        duration: 200,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    this.initEventArray(closeIconOptParam);
    this.initFinishArray(closeIconOptParam);
    if (is4x4) {
      this.openSmallFolderTo4x4Animator.bottomTextParam = openBottomTextParam;
      this.openSmallFolderTo4x4Animator.backgroundParam = openBackgroundParam;
      this.openSmallFolderTo4x4Animator.iconParam = openIconParam;
      this.openSmallFolderTo4x4Animator.titleParam = openTitleParam;
      this.openSmallFolderTo4x4Animator.iconOptParam = openIconOptParam;

      this.closSmallFolderTo4x4Animator.bottomTextParam = closeBottomTextParam;
      this.closSmallFolderTo4x4Animator.backgroundParam = closeBackgroundParam;
      this.closSmallFolderTo4x4Animator.iconParam = closeIconParam;
      this.closSmallFolderTo4x4Animator.titleParam = closeTitleParam;
      this.closSmallFolderTo4x4Animator.iconOptParam = closeIconOptParam;
    } else {
      this.openSmallFolderAnimator.bottomTextParam = openBottomTextParam;
      this.openSmallFolderAnimator.backgroundParam = openBackgroundParam;
      this.openSmallFolderAnimator.iconParam = openIconParam;
      this.openSmallFolderAnimator.titleParam = openTitleParam;
      this.openSmallFolderAnimator.iconOptParam = openIconOptParam;

      this.closeSmallFolderAnimator.bottomTextParam = closeBottomTextParam;
      this.closeSmallFolderAnimator.backgroundParam = closeBackgroundParam;
      this.closeSmallFolderAnimator.iconParam = closeIconParam;
      this.closeSmallFolderAnimator.titleParam = closeTitleParam;
      this.closeSmallFolderAnimator.iconOptParam = closeIconOptParam;
    }
  }

  private initSmallFolderNoOrderlyAnimator(): void {
    let curve: ICurve = curves.interpolatingSpring(0, 1, 223.8, 25.4);
    let openBottomTextParam: AnimatorParameter = new AnimatorParameter();
    openBottomTextParam.animatorNames = ['smallFolderToOpenFolderBT'];
    openBottomTextParam.params = [
      {
        duration: 250,
        delay: 250,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(openBottomTextParam);
    this.initFinishArray(openBottomTextParam);
    this.openSmallFolderNoSequencesAnimator.bottomTextParam = openBottomTextParam;

    let openBackgroundParam: AnimatorParameter = new AnimatorParameter();
    openBackgroundParam.animatorNames = ['smallFolderToOpenFolderBG'];
    openBackgroundParam.params = [
      {
        duration: 200,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(openBackgroundParam);
    this.initFinishArray(openBackgroundParam);
    this.openSmallFolderNoSequencesAnimator.backgroundParam = openBackgroundParam;

    let openIconParam: AnimatorParameter = new AnimatorParameter();
    openIconParam.animatorNames = ['smallFolderToOpenFolderIcon'];
    openIconParam.params = [
      {
        duration: 500,
        curve: curve,
      }
    ];
    this.initEventArray(openIconParam);
    this.initFinishArray(openIconParam);
    this.openSmallFolderNoSequencesAnimator.iconParam = openIconParam;

    let openTitleParam: AnimatorParameter = new AnimatorParameter();
    openTitleParam.animatorNames = ['smallFolderToOpenFolderTitle'];
    openTitleParam.params = [
      {
        duration: 100,
        delay: 200,
      }
    ];
    this.initEventArray(openTitleParam);
    this.initFinishArray(openTitleParam);
    this.openSmallFolderNoSequencesAnimator.titleParam = openTitleParam;

    let closeBackgroundParam: AnimatorParameter = new AnimatorParameter();
    closeBackgroundParam.animatorNames = ['OpenFolderToSmallFolderBG'];
    closeBackgroundParam.params = [
      {
        duration: 200,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeBackgroundParam);
    this.initFinishArray(closeBackgroundParam);
    this.closeSmallFolderNoSequencesAnimator.backgroundParam = closeBackgroundParam;

    let closeIconParam: AnimatorParameter = new AnimatorParameter();
    closeIconParam.animatorNames = ['OpenFolderToSmallFolderIcon'];
    closeIconParam.params = [
      {
        duration: 500,
        curve: curve,
      }
    ];
    this.initEventArray(closeIconParam);
    this.initFinishArray(closeIconParam);
    this.closeSmallFolderNoSequencesAnimator.iconParam = closeIconParam;

    let closeTitleParam: AnimatorParameter = new AnimatorParameter();
    closeTitleParam.animatorNames = ['OpenFolderToSmallFolderTitle'];
    closeTitleParam.params = [
      {
        duration: 100,
      }
    ];
    this.initEventArray(closeTitleParam);
    this.initFinishArray(closeTitleParam);
    this.closeSmallFolderNoSequencesAnimator.titleParam = closeTitleParam;
  }

  private initBigFolderAnimator(): void {
    let curve: ICurve = curves.interpolatingSpring(0, 1, 503.6, 39.9);

    // 大文件夹打开动效秩序感时，图标名称需要按批次依次出现
    let openBottomTextParam: AnimatorParameter = new AnimatorParameter();
    openBottomTextParam.animatorNames = ['bigFolderToOpenFolderBT'];
    openBottomTextParam.params = [{
      duration: 150,
      delay: 150,
      curve: Curve.Linear,
    }];
    this.initEventArray(openBottomTextParam);
    this.initFinishArray(openBottomTextParam);
    this.openBigFolderAnimator.bottomTextParam = openBottomTextParam;

    // index0：背板透明度动效，index1：背板位移缩放动效
    let openBackgroundParam: AnimatorParameter = new AnimatorParameter();
    openBackgroundParam.animatorNames = ['bigFolderToOpenFolderBG', 'bigFolderToOpenFolderBGTrans'];
    openBackgroundParam.params.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
    });
    openBackgroundParam.params.push({
      curve: curve,
    });
    this.initEventArray(openBackgroundParam);
    this.initFinishArray(openBackgroundParam);
    this.openBigFolderAnimator.backgroundParam = openBackgroundParam;

    let openIconParam: AnimatorParameter = new AnimatorParameter();
    openIconParam.animatorNames = OPEN_BIG_FOLDER_ANIS;
    for (let i = 0; i < OPEN_BIG_FOLDER_ANIS.length; i++) {
      openIconParam.params.push({
        delay: 16.67 * i,
        curve: curve,
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    this.initEventArray(openIconParam);
    this.initFinishArray(openIconParam);
    this.openBigFolderAnimator.iconParam = openIconParam;

    let openTitleParam: AnimatorParameter = new AnimatorParameter();
    openTitleParam.animatorNames = ['bigFolderToOpenFolderTitle'];
    openTitleParam.params = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    this.initEventArray(openTitleParam);
    this.initFinishArray(openTitleParam);
    this.openBigFolderAnimator.titleParam = openTitleParam;

    let openIconOptParam: AnimatorParameter = new AnimatorParameter();
    openIconOptParam.animatorNames = OPEN_BIG_FOLDER_ICON_OPT_ANIS;
    for (let i = 0; i < OPEN_BIG_FOLDER_ICON_OPT_ANIS.length; i++) {
      openIconOptParam.params.push({
        duration: 250,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    this.initEventArray(openIconOptParam);
    this.initFinishArray(openIconOptParam);
    this.openBigFolderAnimator.iconOptParam = openIconOptParam;

    // 关闭大文件夹时底部文字统一进行消失动效
    let closeBottomTextParam: AnimatorParameter = new AnimatorParameter();
    closeBottomTextParam.animatorNames = ['OpenFolderToBigFolderBT'];
    closeBottomTextParam.params = [
      {
        duration: 100,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeBottomTextParam);
    this.initFinishArray(closeBottomTextParam);
    this.closeBigFolderAnimator.bottomTextParam = closeBottomTextParam;

    // index0：背板透明度动效，index1：背板位移缩放动效
    let closeBackgroundParam: AnimatorParameter = new AnimatorParameter();
    closeBackgroundParam.animatorNames = ['OpenFolderToBigFolderBG', 'OpenFolderToBigFolderBGTrans'];
    closeBackgroundParam.params.push({
      duration: 250,
      delay: 50,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    closeBackgroundParam.params.push({
      delay: 50,
      curve: curve,
    });
    this.initEventArray(closeBackgroundParam);
    this.initFinishArray(closeBackgroundParam);
    this.closeBigFolderAnimator.backgroundParam = closeBackgroundParam;

    let closeIconParam: AnimatorParameter = new AnimatorParameter();
    closeIconParam.animatorNames = CLOSE_BIG_FOLDER_ANIS;
    for (let i = 0; i < CLOSE_BIG_FOLDER_ANIS.length; i++) {
      closeIconParam.params.push({
        delay: 16.67 * i,
        curve: curve,
        finishCallbackType: FinishCallbackType.LOGICALLY,
      });
    }
    this.initEventArray(closeIconParam);
    this.initFinishArray(closeIconParam);
    this.closeBigFolderAnimator.iconParam = closeIconParam;

    let closeTitleParam: AnimatorParameter = new AnimatorParameter();
    closeTitleParam.animatorNames = ['OpenFolderToBigFolderTitle'];
    closeTitleParam.params = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeTitleParam);
    this.initFinishArray(closeTitleParam);
    this.closeBigFolderAnimator.titleParam = closeTitleParam;

    let closeIconOptParam: AnimatorParameter = new AnimatorParameter();
    closeIconOptParam.animatorNames = CLOSE_BIG_FOLDER_ICON_OPT_ANIS;
    for (let i = 0; i < CLOSE_BIG_FOLDER_ICON_OPT_ANIS.length; i++) {
      closeIconOptParam.params.push({
        duration: 200,
        delay: 16.67 * i,
        curve: Curve.Linear,
      });
    }
    this.initEventArray(closeIconOptParam);
    this.initFinishArray(closeIconOptParam);
    this.closeBigFolderAnimator.iconOptParam = closeIconOptParam;
  }

  private init4x2BigFolderAnimator(): void {
    let curve: ICurve = curves.interpolatingSpring(0, 1, 322.3, 32);

    let openBottomTextParam: AnimatorParameter = new AnimatorParameter();
    openBottomTextParam.animatorNames = OPEN_4x2_BIG_FOLDER_ICON_NAME_ANIS;
    for (let i = 0; i < OPEN_4x2_BIG_FOLDER_ICON_NAME_ANIS.length; i++) {
      openBottomTextParam.params.push({
        duration: 150,
        delay: 150 + 33.34 * i,
        curve: Curve.Linear,
      });
    }
    this.initEventArray(openBottomTextParam);
    this.initFinishArray(openBottomTextParam);
    this.open4x2BigFolderAnimator.bottomTextParam = openBottomTextParam;

    let openBackgroundParam: AnimatorParameter = new AnimatorParameter();
    openBackgroundParam.animatorNames = ['4x2BigFolderToOpenFolderBgOpt', '4x2BigFolderToOpenFolderBgTrans'];
    openBackgroundParam.params.push({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
    });
    openBackgroundParam.params.push({
      curve: curve,
    });
    this.initEventArray(openBackgroundParam);
    this.initFinishArray(openBackgroundParam);
    this.open4x2BigFolderAnimator.backgroundParam = openBackgroundParam;

    let openIconParam: AnimatorParameter = new AnimatorParameter();
    openIconParam.animatorNames = ['4x2BigFolderToOpenFolderIcon', '4x2BigFolderToOpenFolderIcon1'];
    openIconParam.params.push({
      curve: curve,
      finishCallbackType: FinishCallbackType.LOGICALLY,
    });
    openIconParam.params.push({
      delay: 33.34,
      curve: curve,
      finishCallbackType: FinishCallbackType.LOGICALLY,
    });
    this.initEventArray(openIconParam);
    this.initFinishArray(openIconParam);
    this.open4x2BigFolderAnimator.iconParam = openIconParam;

    let openHiddenIconParam: AnimatorParameter = new AnimatorParameter();
    openHiddenIconParam.animatorNames = ['4x2BigFolderToOpenFolderHiddenIcon', '4x2BigFolderToOpenFolderHiddenIcon1'];
    openHiddenIconParam.params.push({
      duration: 50,
      curve: Curve.Linear,
    });
    openHiddenIconParam.params.push({
      duration: 50,
      delay: 33.34,
      curve: Curve.Linear,
    });
    this.initEventArray(openHiddenIconParam);
    this.initFinishArray(openHiddenIconParam);
    this.open4x2BigFolderAnimator.iconOptParam = openHiddenIconParam;

    let openTitleParam: AnimatorParameter = new AnimatorParameter();
    openTitleParam.animatorNames = ['4x2BigFolderToOpenFolderTitle'];
    openTitleParam.params = [
      {
        duration: 500,
        curve: Curve.Friction,
      }
    ];
    this.initEventArray(openTitleParam);
    this.initFinishArray(openTitleParam)
    this.open4x2BigFolderAnimator.titleParam = openTitleParam;

    let closeBottomTextParam: AnimatorParameter = new AnimatorParameter();
    closeBottomTextParam.animatorNames = ['OpenFolderTo4x2BigOpenFolderBT'];
    closeBottomTextParam.params = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeBottomTextParam);
    this.initFinishArray(closeBottomTextParam)
    this.close4x2BigFolderAnimator.bottomTextParam = closeBottomTextParam;

    let closeBackgroundParam: AnimatorParameter = new AnimatorParameter();
    closeBackgroundParam.animatorNames = ['OpenFolderTo4x2BigOpenFolderBgOpt', 'OpenFolderTo4x2BigOpenFolderBgTrans'];
    closeBackgroundParam.params.push({
      duration: 250,
      delay: 50,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
    });
    closeBackgroundParam.params.push({
      delay: 50,
      curve: curve,
    });
    this.initEventArray(closeBackgroundParam);
    this.initFinishArray(closeBackgroundParam);
    this.close4x2BigFolderAnimator.backgroundParam = closeBackgroundParam;

    let closeIconParam: AnimatorParameter = new AnimatorParameter();
    closeIconParam.animatorNames = ['OpenFolderTo4x2BigOpenFolderIcon', 'OpenFolderTo4x2BigOpenFolderIcon1'];
    closeIconParam.params.push({
      curve: curve,
      finishCallbackType: FinishCallbackType.LOGICALLY,
    });
    closeIconParam.params.push({
      curve: curve,
      delay: 33.34,
      finishCallbackType: FinishCallbackType.LOGICALLY,
    });
    this.initEventArray(closeIconParam);
    this.initFinishArray(closeIconParam);
    this.close4x2BigFolderAnimator.iconParam = closeIconParam;

    this.addClose4x2FolderIconOptAni();

    let closeTitleParam: AnimatorParameter = new AnimatorParameter();
    closeTitleParam.animatorNames = ['OpenFolderTo4x2BigOpenFolderTitle'];
    closeTitleParam.params = [
      {
        duration: 150,
        curve: Curve.Linear,
      }
    ];
    this.initEventArray(closeTitleParam);
    this.initFinishArray(closeTitleParam)
    this.close4x2BigFolderAnimator.titleParam = closeTitleParam;
  }

  private addClose4x2FolderIconOptAni() {
    let closeHiddenIconParam: AnimatorParameter = new AnimatorParameter();
    closeHiddenIconParam.animatorNames =
      ['OpenFolderTo4x2BigFolderHiddenIcon', 'OpenFolderTo4x2BigFolderHiddenAddIcon'];
    closeHiddenIconParam.params.push({
      duration: 150,
      delay: 150,
      curve: Curve.Friction,
    });
    closeHiddenIconParam.params.push({
      duration: 200,
      curve: Curve.Friction,
    });
    this.initEventArray(closeHiddenIconParam);
    this.initFinishArray(closeHiddenIconParam);
    this.close4x2BigFolderAnimator.iconOptParam = closeHiddenIconParam;
  }

  private initEventArray(param: AnimatorParameter): void {
    for (let i = 0; i < param.animatorNames.length; i++) {
      param.eventArray.push([]);
    }
  }

  private initFinishArray(param: AnimatorParameter): void {
    for (let i = 0; i < param.animatorNames.length; i++) {
      param.finishArray.push([]);
    }
  }
}

export let aniParamModel: AnimationParameterModel = SingletonHelper.getInstance(AnimationParameterModel, TAG);