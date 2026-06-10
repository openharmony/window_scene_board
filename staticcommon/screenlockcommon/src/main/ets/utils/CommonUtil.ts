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

import { ArrayUtils, CheckEmptyUtils, Log } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { util } from '@kit.ArkTS';
import { uiEffect } from '@kit.ArkGraphics2D';

const TAG = 'CommonUtil';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

const regex: RegExp = new RegExp('rgba?\\((\\d+),\\s*(\\d+),\\s*(\\d+)(?:,\\s*[\\d.]+)?\\)', 'i');

export class CommonUtil {
  public static runWithoutException(logTag: string, logMsg: string, executeFunc: Function): void {
    try {
      executeFunc?.();
    } catch (e) {
      Log.error(logTag, `${logMsg} exception`, e);
    }
  }

  public static constrain(amount: number, low: number, high: number): number {
    return amount < low ? low : (amount > high ? high : amount);
  }

  /**
   * 用于去除RGB格式颜色的透明度
   *
   * @param textColor rgb格式颜色字符串
   * @returns 去除透明度后的颜色
   */
  public static removeColorCapacity(textColor: string): string {
    if (!textColor) {
      return textColor;
    }
    const match = textColor.match(regex);
    if (match) {
      const r = match[1];
      const g = match[2];
      const b = match[3];
      const newColor = `rgb(${r}, ${g}, ${b})`;
      return newColor;
    }
    return textColor;
  }

  /**
   * 根据路径加载图片
   *
   * @param path 图片路径
   * @returns 图片资源
   */
  public static async loadImageFromDisk(path: string,
    format: image.PixelMapFormat = image.PixelMapFormat.RGBA_8888): Promise<image.PixelMap | undefined> {
    if (!path || !fs.access(path)) {
      return undefined;
    }
    let fd: number = -1;
    try {
      fd = fs.openSync(path, fs.OpenMode.READ_ONLY).fd;
      const imageSource: image.ImageSource = image.createImageSource(fd);
      const imageItem = await imageSource.createPixelMap({
        desiredPixelFormat: format,
      });
      await imageSource.release();
      log.showInfo(`loadImageFromDisk success PixelBytes: ${imageItem?.getPixelBytesNumber()}`);
      return imageItem;
    } catch (e) {
      log.showError('loadImageFromDisk error');
    } finally {
      if (fd !== -1) {
        fs.closeSync(fd);
      }
    }
    return undefined;
  }

  /**
   * 比较两个对象内容是否相同
   * @param objA 参与比较的对象A
   * @param objB 参与比较的对象B
   * @returns true比较的两个对象属性完全相同，否则false
   */
  static isAllPropertyEquals<T>(objA: T, objB: T): boolean {
    let hasAnyDiff: boolean = false;
    for (const key in objA) {
      if (!Object.prototype.hasOwnProperty.call(objA, key)) {
        continue;
      }
      if (typeof objA[key] === 'object' && typeof objA[key] !== null) {
        if (Array.isArray(objA[key])) {
          hasAnyDiff = !ArrayUtils.equalsArr(objA[key] as [], objB[key] as []);
        } else {
          hasAnyDiff = !this.isAllPropertyEquals(objA[key], objB[key]);
        }
      } else {
        hasAnyDiff = objA[key] !== objB[key];
      }
      if (hasAnyDiff) {
        return !hasAnyDiff;
      }
    }
    return !hasAnyDiff;
  }

  /**
   * Uint8Array数据转化为JSON对象
   *
   * @param info Uint8Array数据
   * @returns
   */
  public static uint8ArrayToJson(info: Uint8Array): object | null {
    let str: string = String.fromCharCode(...info);
    if (CheckEmptyUtils.isEmpty(str)) {
      log.showInfo('Info str is empty.');
      return null;
    }
    let jsonObject: object = JSON.parse(str);
    return jsonObject;
  }

  /**
   * Uint8Array数据转化为string对象
   *
   * @param info Uint8Array数据
   * @returns
   */
  public static uint8ArrayToString(info?: Uint8Array): string {
    let str = util.generateRandomUUID();
    if (info && info.length > 0) {
      try {
        let textDecode = util.TextDecoder.create('utf-8', { ignoreBOM: true });
        str = textDecode.decodeWithStream(info);
      } catch (err) {
        log.showError('uint8ArrayToString error');
      }
    } else {
      log.showWarn('uint8ArrayToString info is null');
    }
    return str;
  }

  /**
   * 将旧的提亮参数转换为新接口提亮参数
   *
   * @param brightness 旧的提亮参数
   * @returns 新接口提亮参数
   */
  public static translateBrightnessToVisualEffect(brightness: ESObject): uiEffect.VisualEffect | undefined {
    if (!brightness) {
      return undefined;
    }
    let effect: uiEffect.VisualEffect = uiEffect.createEffect();
    let blender: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
      cubicRate: brightness.cubicCoeff,
      quadraticRate: brightness.quadCoeff,
      linearRate: brightness.rate,
      degree: brightness.lightUpDegree,
      saturation: brightness.saturation,
      positiveCoefficient: brightness.posRGB,
      negativeCoefficient: brightness.negRGB,
      fraction: brightness.fraction
    });
    effect.backgroundColorBlender(blender);
    return effect;
  }

  public static hexToRgba(hex: string): number[] {
    // 判断16进制颜色是否合法
    const regex = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;
    const result = regex.exec(hex);
    const rgba: number[] = [];
    if (!result) {
      return rgba;
    }
    if ((result as RegExpExecArray).length !== 4) {
      return rgba;
    }
    rgba.push(parseInt(result[1], 16))
    rgba.push(parseInt(result[2], 16))
    rgba.push(parseInt(result[3], 16))
    return rgba;
  }
}