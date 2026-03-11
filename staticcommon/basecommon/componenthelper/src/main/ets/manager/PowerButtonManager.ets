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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { fileIo as fs, Options } from '@kit.CoreFileKit';
import { configPolicy } from '@kit.BasicServicesKit';
import display from '@ohos.display';

const TAG = 'PowerButtonManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const CONFIG_FILE_PATH = 'etc/ai/ai_animation_power_key_config.json';
const MM_PER_INCH = 25.4;

export interface PowerButton {
  x: number;
  y: number;
  l: number;
}

interface PowerKey {
  side: 'top' | 'bottom' | 'left' | 'right';
  centerOffset: number;
  length: number;
}

interface AaArea {
  width: number;
  height: number;
}

interface PowerKeyConfig {
  rotation: number;
  width: number;
  height: number;
  aaArea: AaArea;
  powerKey: PowerKey;
}

interface PowerKeyCenterPixelConfig {
  powerKeyCenterPixelPosition: PowerButton;
  defaultRotation: number;
  displayWidth: number;
  displayHeight: number;
}

type PowerKeyConfigArray = PowerKeyConfig[];

type PowerKeyCenterPixelConfigArray = PowerKeyCenterPixelConfig[];

/**
 * PowerButtonManager
 *
 * @since 2025-06-21
 */
export class PowerButtonManager {

  private powerKeyConfigArray?: PowerKeyCenterPixelConfigArray;

  /**
   * 电源键信息配置参数初始化
   */
  public init(): void {
    log.showInfo('load PowerButtonManager config');
    try {
      this.powerKeyConfigArray = this.getPowerKeyConfigArray();
    } catch (err) {
      log.showError(`Error on load effects file, error ${err.message}`);
    }
  }

  /**
   * 获取电源键中心点位置及长度
   * @returns 电源键中心点位置及长度信息
   */
  public getCurrentPowerKeyCenterPowerButton(): PowerButton | string {
    try {
      if (!this.powerKeyConfigArray) {
        this.init();
        if (!this.powerKeyConfigArray) {
          log.showError('powerKeyCenterPixelConfigArray is null');
          return 'powerKeyCenterPixelConfigArray is null';
        }
      }
      const displayInfo = display.getDefaultDisplaySync();
      const currentRotation: number = displayInfo.rotation;
      const powerKeyCenterPixelConfigFiltered =
        this.powerKeyConfigArray.filter(cfg => {
          const expectedRotation = cfg.defaultRotation;
          const delta = (currentRotation - expectedRotation + 4) % 4;

          let rotatedWidth = cfg.displayWidth;
          let rotatedHeight = cfg.displayHeight;
          // 90° 或 270°，宽高对调
          if (delta % 2 === 1) {
            rotatedWidth = cfg.displayHeight;
            rotatedHeight = cfg.displayWidth;
          }

          return rotatedWidth === displayInfo.width && rotatedHeight === displayInfo.height;
        })
      if (powerKeyCenterPixelConfigFiltered.length === 0) {
        throw new Error('no display match, please check config!');
      } else if (powerKeyCenterPixelConfigFiltered.length > 1) {
        throw new Error('more than one display match, please check config!');
      }
      const powerKeyCenterPixelConfig = powerKeyCenterPixelConfigFiltered[0]
      const postionRotated = this.rotatePosition(powerKeyCenterPixelConfig, currentRotation)
      return postionRotated;
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : JSON.stringify(err);
      log.showError(`errorMessage = ${errorMessage}`);
      return errorMessage;
    }
  }

  private rotatePosition(powerKeyCenterPixelConfig: PowerKeyCenterPixelConfig,
    currentRotation: number): PowerButton {
    const powerKeyCenterPixelPosition = powerKeyCenterPixelConfig.powerKeyCenterPixelPosition;
    const fromRotation = powerKeyCenterPixelConfig.defaultRotation;
    const width = powerKeyCenterPixelConfig.displayWidth;
    const height = powerKeyCenterPixelConfig.displayHeight;

    const rotated: PowerButton =
      this.rotateBetweenRotations(powerKeyCenterPixelPosition, width, height, fromRotation, currentRotation);

    return {
      x: Math.round(rotated.x),
      y: Math.round(rotated.y),
      l: Math.round(rotated.l),
    };
  }

  private rotateBetweenRotations(
    powerKeyCenterPixelPosition: PowerButton,
    width: number,
    height: number,
    fromRotation: number,
    toRotation: number
  ): PowerButton {
    const delta: number = (toRotation - fromRotation + 4) % 4;
    const x: number = powerKeyCenterPixelPosition.x;
    const y: number = powerKeyCenterPixelPosition.y;
    const l: number = powerKeyCenterPixelPosition.l;

    switch (delta) {
      case 0:
        // 手机处于默认角度
        return { x, y, l };
      case 1:
        // 手机处于逆时针旋转90°的状态
        return { x: height - y, y: x, l: l };
      case 2:
        // 手机处于顺时针旋转90°的状态
        return { x: width - x, y: height - y, l: l };
      case 3:
        // 手机处于旋转180°的状态
        return { x: y, y: width - x, l: l };
      default:
        throw new Error(`illegal delta rotation :${delta}`);
    }
  }

  private getPowerKeyConfigArray(): PowerKeyCenterPixelConfigArray {
    const configFilePath = configPolicy.getOneCfgFileSync(CONFIG_FILE_PATH);
    if (configFilePath === null || configFilePath.trim() === '') {
      throw new Error('no config json file exist!');
    }
    const configJson = this.readJsonFileSync(configFilePath);
    if (configJson.trim() === '') {
      throw new Error('config json empty!');
    }
    const powerKeyConfigArray = JSON.parse(configJson) as PowerKeyConfigArray;
    const powerKeyCenterPixelConfigArray = powerKeyConfigArray.map((cfg, i) => {
      const powerKeyCenterPixelPosition = this.computePowerKeyCenterPixelPosition(cfg);
      const powerKeyCenterPixelConfig = {
        powerKeyCenterPixelPosition: powerKeyCenterPixelPosition,
        defaultRotation: cfg.rotation,
        displayWidth: cfg.width,
        displayHeight: cfg.height
      } as PowerKeyCenterPixelConfig;
      return powerKeyCenterPixelConfig;
    });
    return powerKeyCenterPixelConfigArray;
  }

  private readJsonFileSync(filePath: string): string {
    let options: Options = { encoding: 'utf-8' };
    let readerIterator = fs.readLinesSync(filePath, options);
    let content = '';
    for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
      content += it.value;
    }
    return content;
  }

  private computePowerKeyCenterPixelPosition(config: PowerKeyConfig): PowerButton {
    // mm → px 计算逻辑
    const mmToPx = (mm: number, dpi: number): number => mm * dpi / MM_PER_INCH;

    const xdpi = config.width * MM_PER_INCH / config.aaArea.width;
    const ydpi = config.height * MM_PER_INCH / config.aaArea.height;
    let ldpi = xdpi;

    const aaWidthPx = mmToPx(config.aaArea.width, xdpi);
    const aaHeightPx = mmToPx(config.aaArea.height, ydpi);

    const isFullscreen = Math.abs(aaWidthPx - config.width) < 1 && Math.abs(aaHeightPx - config.height) < 1;
    const offsetX = isFullscreen ? 0 : (config.width - aaWidthPx) / 2;
    const offsetY = isFullscreen ? 0 : (config.height - aaHeightPx) / 2;

    let xMm: number = 0;
    let yMm: number = 0;
    switch (config.powerKey.side) {
      case 'top':
        xMm = config.powerKey.centerOffset;
        yMm = 0;
        break;
      case 'bottom':
        xMm = config.powerKey.centerOffset;
        yMm = config.aaArea.height;
        ldpi = ydpi;
        break;
      case 'left':
        xMm = 0;
        yMm = config.powerKey.centerOffset;
        break;
      case 'right':
        xMm = config.aaArea.width;
        yMm = config.powerKey.centerOffset;
        ldpi = ydpi;
        break;
      default:
        throw new Error(`not supported side: ${config.powerKey.side}`);
    }

    const xPx = mmToPx(xMm, xdpi) + offsetX;
    const yPx = mmToPx(yMm, ydpi) + offsetY;
    const lPx = mmToPx(config.powerKey.length, ldpi);
    const powerKeyCenterPixelPosition = {
      x: Math.round(xPx),
      y: Math.round(yPx),
      l: Math.round(lPx),
    } as PowerButton;
    return powerKeyCenterPixelPosition;
  }
}

// 单例
export let powerButtonManager: PowerButtonManager = SingletonHelper.getInstance(PowerButtonManager, TAG);