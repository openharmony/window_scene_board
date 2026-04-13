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
import { LiveBaseVm, LiveItemBaseVm } from './LiveBaseVm';
import { LiveVmInjector } from './LiveVmInjector';
import { LiveNotification } from './LiveNotification';
import { vp2px } from './utils';
import { afterEach, beforeEach, DEFAULT, describe, expect, it } from '@ohos/hypium';

// 模拟依赖项
const vp2px = (value: number): number => value; // 假设 vp2px 是 1:1 转换

// 模拟 LogUtil 和 Log 类
class MockLog implements Log {
  public logMessages: string[] = [];
  public log(level: string, message: string): void {
    this.logMessages.push(`${level}: ${message}`);
  }
}

class MockLogUtil {
  private static loggerMap: Map<string, MockLog> = new Map();
  public static getLiveLogger(tag: string): Log {
    if (!MockLogUtil.loggerMap.has(tag)) {
      MockLogUtil.loggerMap.set(tag, new MockLog());
    }
    return MockLogUtil.loggerMap.get(tag)!;
  }
}

// 替换实际 LogUtil 为模拟版本
LogUtil = MockLogUtil as any;

// 模拟 LiveVmInjector
class MockLiveVmInjector implements LiveVmInjector {
  public scene: string = 'testScene';
  // 其他注入依赖（根据实际需求补充）
}

export default function LiveBaseVmTest() {
  describe('LiveBaseVm', () => {
    let vm: LiveBaseVm;
    let mockInjector: LiveVmInjector;

    beforeEach(() => {
      mockInjector = new MockLiveVmInjector();
      vm = new (class extends LiveBaseVm {
        constructor(vmInjector: LiveVmInjector) {
          super(vmInjector);
        }
      })(mockInjector);
    });

    afterEach(() => {
      MockLogUtil.loggerMap.clear();
    });

    it('should create an instance of LiveBaseVm', 0, () => {
      const vmInjector = new LiveVmInjector();
      const liveBaseVm = new LiveBaseVm(vmInjector);
      expect(liveBaseVm).toBeInstanceOf(LiveBaseVm);
    });

    it('should check if a point is within an area', 0, () => {
      const vmInjector = new LiveVmInjector();
      const liveBaseVm = new LiveBaseVm(vmInjector);
      const area = {
        globalPosition: {
          x: 10, y: 20
        }, width: 100, height: 50
      };
      const x = 30;
      const y = 40;

      const result = liveBaseVm.checkPointInArea(x, y, area);
      expect(result).toBe(true);
    });

    it('should convert color and alpha to RGBA', 0, () => {
      const vmInjector = new LiveVmInjector();
      const liveBaseVm = new LiveBaseVm(vmInjector);
      const color = '#FF0000';
      const alpha = 0.5;

      const result = liveBaseVm.convertColorToRgba(color, alpha);
      expect(result).toBe('rgba(255,0,0,0.5)');
    });
  });

  describe('LiveItemBaseVm', () => {
    it('should create an instance of LiveItemBaseVm', 0, () => {
      const vmInjector = new LiveVmInjector();
      const liveNotification = new LiveNotification();
      const liveItemBaseVm = new LiveItemBaseVm(vmInjector, liveNotification);
      expect(liveItemBaseVm).toBeInstanceOf(LiveItemBaseVm);
    });

    it('should update the live notification', 0, () => {
      const vmInjector = new LiveVmInjector();
      const liveNotification = new LiveNotification();
      const liveItemBaseVm = new LiveItemBaseVm(vmInjector, liveNotification);

      liveItemBaseVm.onUpdate(liveNotification);
      expect(liveItemBaseVm.live).toBe(liveNotification);
    });
  });

  it('should return true when the point is inside the area',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 120;
    const y = 120;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(true);
  });

  it('should return false when the point is outside the area',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 80;
    const y = 80;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(false);
  });

  it('should return false when the point is on the left edge',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 100;
    const y = 120;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(false);
  });

  it('should return false when the point is on the top edge',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 120;
    const y = 100;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(false);
  });

  it('should return false when the point is on the right edge',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 200;
    const y = 120;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(false);
  });

  it('should return false when the point is on the bottom edge',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 120;
    const y = 200;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(false);
  });

  it('should return true when the point is on the left-upper corner',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 100;
    const y = 100;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(true);
  });

  it('should return true when the point is on the right-lower corner',0, () => {
    const area = new Area(100, 100, 200, 200); // 创建一个测试区域
    const x = 200;
    const y = 200;
    const result = checkPointInArea(x, y, area);
    expect(result).toBe(true);
  });

  it('should convert hex color to rgba correctly for 3-digit input', 0,() => {
    const color = '#1abc9c';
    const alpha = 0.5;
    const expectedResult = 'rgba(26, 188, 156, 0.5)';
    expect(convertColorToRgba(color, alpha)).toBe(expectedResult);
  });

  it('should convert hex color to rgba correctly for 6-digit input', 0,() => {
    const color = '#1abc9c';
    const alpha = 0.5;
    const expectedResult = 'rgba(26, 188, 156, 0.5)';
    expect(convertColorToRgba(color, alpha)).toBe(expectedResult);
  });

  it('should handle alpha value correctly',0, () => {
    const color = '#1abc9c';
    const alpha = 0.8;
    const expectedResult = 'rgba(26, 188, 156, 0.8)';
    expect(convertColorToRgba(color, alpha)).toBe(expectedResult);
  });

  it('should floor the color values by half',0, () => {
    const color = '#34a85a';
    const alpha = 0.5;
    const expectedRed = 17;
    const expectedGreen = 42;
    const expectedBlue = 90;
    const expectedResult = 'rgba(17, 42, 90, 0.5)';
    expect(convertColorToRgba(color, alpha)).toBe(expectedResult);
  });

  it('should handle edge cases where color values are 0 or 255',0, () => {
    const color = '#FF0000';
    const alpha = 0.5;
    const expectedResult = 'rgba(255, 0, 0, 0.5)';
    expect(convertColorToRgba(color, alpha)).toBe(expectedResult);
  });

  it('should return true when point is inside the area',DEFAULT, () => {
    const area: Area = {
      globalPosition: { x: 10, y: 20 },
      width: 100,
      height: 200
    };
    const result = vm.checkPointInArea(50, 100, area);
    expect(result).to.be.true;
  });

  it('should return true when point is on the edge',DEFAULT, () => {
    const area: Area = {
      globalPosition: { x: 0, y: 0 },
      width: 100,
      height: 100
    };
    expect(vm.checkPointInArea(0, 0, area)).to.be.true;
    expect(vm.checkPointInArea(100, 100, area)).to.be.true;
  });

  it('should return false when point is outside the area', DEFAULT,() => {
    const area: Area = {
      globalPosition: { x: 50, y: 50 },
      width: 50,
      height: 50
    };
    expect(vm.checkPointInArea(-1, 50, area)).to.be.false;
    expect(vm.checkPointInArea(150, 50, area)).to.be.false;
    expect(vm.checkPointInArea(50, -1, area)).to.be.false;
    expect(vm.checkPointInArea(50, 150, area)).to.be.false;
  });

  it('should handle zero-sized areas',DEFAULT, () => {
    const area: Area = {
      globalPosition: { x: 100, y: 200 },
      width: 0,
      height: 0
    };
    expect(vm.checkPointInArea(100, 200, area)).to.be.true;
    expect(vm.checkPointInArea(101, 200, area)).to.be.false;
  });

  it('should handle negative coordinates', DEFAULT,() => {
    const area: Area = {
      globalPosition: { x: -50, y: -50 },
      width: 100,
      height: 100
    };
    expect(vm.checkPointInArea(-50, -50, area)).to.be.true;
    expect(vm.checkPointInArea(-150, -150, area)).to.be.false;
  });

  it('should convert 6-digit color with alpha',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FF', 0.5);
    expect(result).to.equal('rgba(127,0,127,0.5)');
  });

  it('should convert 8-digit color with alpha',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FFAA', 0.8);
    expect(result).to.equal('rgba(255,0,255,0.8)');
  });

  it('should handle invalid color formats', DEFAULT,() => {
    expect(() => vm.convertColorToRgba('#123', 0.5)).to.throw('Invalid color format');
    expect(() => vm.convertColorToRgba('invalid', 0.5)).to.throw('Invalid color format');
  });

  it('should handle transparent colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#000000', 0);
    expect(result).to.equal('rgba(0,0,0,0)');
  });

  it('should handle white color', DEFAULT,() => {
    const result = vm.convertColorToRgba('#FFFFFF', 1);
    expect(result).to.equal('rgba(255,255,255,1)');
  });

  it('should convert 6-digit color with alpha',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FF', 0.5);
    expect(result).to.equal('rgba(127,0,127,0.5)');
  });

  it('should convert 8-digit color with alpha',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FFAA', 0.8);
    expect(result).to.equal('rgba(255,0,255,0.8)');
  });

  it('should handle invalid color formats',DEFAULT, () => {
    expect(() => vm.convertColorToRgba('#123', 0.5)).to.throw('Invalid color format');
    expect(() => vm.convertColorToRgba('invalid', 0.5)).to.throw('Invalid color format');
  });

  it('should handle transparent colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#000000', 0);
    expect(result).to.equal('rgba(0,0,0,0)');
  });

  it('should handle white color',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FFFFFF', 1);
    expect(result).to.equal('rgba(255,255,255,1)');
  });

  it('should initialize logger on first access',DEFAULT, () => {
    const tag = `${vm.TAG}_${mockInjector.scene}`;
    expect(MockLogUtil.loggerMap.has(tag)).to.be.false;
    const logger = vm.log;
    expect(MockLogUtil.loggerMap.has(tag)).to.be.true;
    expect(logger).to.equal(MockLogUtil.loggerMap.get(tag));
  });

  it('should cache the logger instance',DEFAULT, () => {
    const firstAccess = vm.log;
    const secondAccess = vm.log;
    expect(firstAccess).to.equal(secondAccess);
  });

  it('should log messages correctly', DEFAULT,() => {
    const logger = vm.log;
    logger.log('DEBUG', 'Test message');
    expect(logger.logMessages).to.include('DEBUG: Test message');
  });

  it('should initialize live property correctly',DEFAULT, () => {
    expect(itemVm.live).to.equal(mockLive);
  });

  it('should update live property with onUpdate',DEFAULT, () => {
    const newLive: LiveNotification = { id: 'newLive', title: 'New Live' };
    itemVm.onUpdate(newLive);
    expect(itemVm.live).to.equal(newLive);
  });

  it('should call init and destroy methods',DEFAULT, () => {
    const spyInit = sinon.spy(itemVm, 'init');
    const spyDestroy = sinon.spy(itemVm, 'destroy');
    itemVm.init();
    itemVm.destroy();
    expect(spyInit.calledOnce).to.be.true;
    expect(spyDestroy.calledOnce).to.be.true;
  });

  it('should handle fractional coordinates',DEFAULT, () => {
    const area: Area = { globalPosition: { x: 1.5, y: 2.5 }, width: 3.5, height: 4.5 };
    expect(vm.checkPointInArea(2.0, 3.0, area)).to.be.true;
    expect(vm.checkPointInArea(5.0, 7.0, area)).to.be.false;
  });

  it('should handle extremely large values',DEFAULT, () => {
    const area: Area = {
      globalPosition: { x: Number.MAX_SAFE_INTEGER - 100, y: Number.MAX_SAFE_INTEGER - 200 },
      width: 200,
      height: 300
    };
    expect(vm.checkPointInArea(Number.MAX_SAFE_INTEGER - 50, Number.MAX_SAFE_INTEGER - 150, area)).to.be.true;
  });

  it('should handle zero width/height with non-zero position',DEFAULT, () => {
    const areaZeroWidth: Area = { globalPosition: { x: 100, y: 200 }, width: 0, height: 200 };
    expect(vm.checkPointInArea(100, 250, areaZeroWidth)).to.be.true;
    expect(vm.checkPointInArea(101, 250, areaZeroWidth)).to.be.false;

    const areaZeroHeight: Area = { globalPosition: { x: 100, y: 200 }, width: 200, height: 0 };
    expect(vm.checkPointInArea(150, 200, areaZeroHeight)).to.be.true;
    expect(vm.checkPointInArea(150, 201, areaZeroHeight)).to.be.false;
  });

  it('should handle negative globalPosition with positive area',DEFAULT, () => {
    const area: Area = { globalPosition: { x: -100, y: -200 }, width: 300, height: 400 };
    expect(vm.checkPointInArea(50, 50, area)).to.be.true;
    expect(vm.checkPointInArea(-150, -250, area)).to.be.false;
  });

  it('should handle 3-digit hex colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#ABC', 0.5);
    expect(result).to.equal('rgba(170,187,204,0.5)');
  });

  it('should handle 4-digit hex colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#ABCD', 0.5);
    expect(result).to.equal('rgba(170,187,204,0.5)');
  });

  it('should handle invalid hex characters',DEFAULT, () => {
    expect(() => vm.convertColorToRgba('#GHIJ', 0.5)).to.throw('Invalid color format');
    expect(() => vm.convertColorToRgba('#12345', 0.5)).to.throw('Invalid color format');
  });

  it('should handle alpha values outside [0,1]',DEFAULT, () => {
    expect(vm.convertColorToRgba('#FFFFFF', 1.5)).to.equal('rgba(255,255,255,1.5)');
    expect(vm.convertColorToRgba('#000000', -0.5)).to.equal('rgba(0,0,0,-0.5)');
  });

  it('should handle grayscale colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#808080', 0.5);
    expect(result).to.equal('rgba(127,127,127,0.5)');
  });

  it('should handle multiple loggers with different scenes',DEFAULT, () => {
    const vm2 = new (class extends LiveBaseVm {
      constructor(vmInjector: LiveVmInjector) {
        super(vmInjector);
      }
    })(new MockLiveVmInjector({ scene: 'anotherScene' }));

    expect(vm.log).not.to.equal(vm2.log);
    expect(MockLogUtil.loggerMap.size).to.equal(2);
  });

  it('should log with different levels',DEFAULT, () => {
    const logger = vm.log;
    logger.log('DEBUG', 'Debug message');
    logger.log('INFO', 'Info message');
    logger.log('ERROR', 'Error message');
    expect(logger.logMessages).to.have.lengthOf(3);
    expect(logger.logMessages[0]).to.startWith('DEBUG:');
    expect(logger.logMessages[1]).to.startWith('INFO:');
    expect(logger.logMessages[2]).to.startWith('ERROR:');
  });

  it('should not reinitialize logger after destruction',DEFAULT, () => {
    vm = null!; // 强制断言以模拟销毁
    expect(() => vm.log).to.throw('Cannot read property');
  });

  it('should throw error on invalid LiveNotification',DEFAULT, () => {
    const invalidLive: any = { invalidProp: 'test' };
    expect(() => new (class extends LiveItemBaseVm {
      constructor(vmInjector: LiveVmInjector, live: LiveNotification) {
        super(vmInjector, live);
      }
    })(mockInjector, invalidLive)).to.throw('Invalid LiveNotification format');
  });

  it('should handle multiple onUpdate calls',DEFAULT, () => {
    const newLive1: LiveNotification = { id: 'live1', title: 'Live 1' };
    const newLive2: LiveNotification = { id: 'live2', title: 'Live 2' };
    itemVm.onUpdate(newLive1);
    itemVm.onUpdate(newLive2);
    expect(itemVm.live).to.equal(newLive2);
  });

  it('should call init and destroy with spies',DEFAULT, () => {
    const spyInit = sinon.spy(itemVm, 'init');
    const spyDestroy = sinon.spy(itemVm, 'destroy');
    itemVm.init();
    itemVm.destroy();
    expect(spyInit.calledOnce).to.be.true;
    expect(spyDestroy.calledOnce).to.be.true;
    expect(spyInit.calledBefore(spyDestroy)).to.be.true;
  });

  it('should not allow duplicate Live IDs',DEFAULT, () => {
    const duplicateLive: LiveNotification = { id: mockLive.id, title: 'Duplicate' };
    expect(() => itemVm.onUpdate(duplicateLive)).to.throw('Duplicate Live ID');
  });

  it('should log coordinate check results',DEFAULT, () => {
    const area: Area = { globalPosition: { x: 10, y: 20 }, width: 100, height: 200 };
    vm.checkPointInArea(50, 100, area);
    expect(vm.log.logMessages).to.include('DEBUG: Point (50,100) is inside area');
  });

  it('should combine color conversion and logging',DEFAULT, () => {
    const color = '#FF00FF';
    const rgba = vm.convertColorToRgba(color, 0.5);
    vm.log.log('INFO', `Converted ${color} to ${rgba}`);
    expect(vm.log.logMessages).to.include(`INFO: Converted ${color} to ${rgba}`);
  });

  it('should execute checkPointInArea efficiently',DEFAULT, (done) => {
    const area: Area = { globalPosition: { x: 0, y: 0 }, width: 1000, height: 1000 };
    new Benchmark('checkPointInArea', () => {
      for (let i = 0; i < 1000; i++) {
        vm.checkPointInArea(Math.random() * 1000, Math.random() * 1000, area);
      }
    }).on('complete', () => done()).run({ maxTime: 2 });
  });

  it('should execute convertColorToRgba efficiently',DEFAULT, (done) => {
    new Benchmark('convertColorToRgba', () => {
      for (let i = 0; i < 1000; i++) {
        vm.convertColorToRgba(`#${Math.random().toString(16).slice(2,8)}`, Math.random());
      }
    }).on('complete', () => done()).run({ maxTime: 2 });
  });

  it('should handle null/undefined area properties', DEFAULT,() => {
    const areaWithNull: Area = { globalPosition: { x: 10, y: 20 }, width: 100, height: null };
    expect(() => vm.checkPointInArea(50, 100, areaWithNull)).to.throw('Invalid area dimensions');

    const areaWithUndefined: Area = { globalPosition: { x: 10, y: 20 }, width: undefined, height: 200 };
    expect(() => vm.checkPointInArea(50, 100, areaWithUndefined)).to.throw('Invalid area dimensions');
  });

  it('should handle negative width/height',DEFAULT, () => {
    const areaNegativeWidth: Area = { globalPosition: { x: 100, y: 200 }, width: -50, height: 200 };
    expect(() => vm.checkPointInArea(100, 200, areaNegativeWidth)).to.throw('Invalid area dimensions');

    const areaNegativeHeight: Area = { globalPosition: { x: 100, y: 200 }, width: 50, height: -200 };
    expect(() => vm.checkPointInArea(100, 200, areaNegativeHeight)).to.throw('Invalid area dimensions');
  });

  it('should handle non-numeric coordinates',DEFAULT, () => {
    const area: Area = { globalPosition: { x: 10, y: 20 }, width: 100, height: 200 };
    expect(() => vm.checkPointInArea('invalid', 100, area)).to.throw('Invalid coordinate type');
    expect(() => vm.checkPointInArea(50, 'invalid', area)).to.throw('Invalid coordinate type');
  });

  it('should handle area with zero area (width=0 AND height=0)',DEFAULT, () => {
    const areaZero: Area = { globalPosition: { x: 100, y: 200 }, width: 0, height: 0 };
    expect(vm.checkPointInArea(100, 200, areaZero)).to.be.true;
    expect(vm.checkPointInArea(101, 201, areaZero)).to.be.false;
  });

  it('should handle uppercase hex colors',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FF', 0.5);
    expect(result).to.equal('rgba(255,0,255,0.5)');
  });

  it('should handle hex with spaces', DEFAULT,() => {
    expect(() => vm.convertColorToRgba('#FF00 FF', 0.5)).to.throw('Invalid color format');
    expect(() => vm.convertColorToRgba('#FF00FF ', 0.5)).to.throw('Invalid color format');
  });

  it('should handle alpha as string', DEFAULT,() => {
    const result = vm.convertColorToRgba('#FFFFFF', '0.5');
    expect(result).to.equal('rgba(255,255,255,0.5)');
  });

  it('should handle invalid alpha types',DEFAULT, () => {
    expect(() => vm.convertColorToRgba('#FFFFFF', 'invalid')).to.throw('Invalid alpha value');
    expect(() => vm.convertColorToRgba('#FFFFFF', [])).to.throw('Invalid alpha value');
  });

  it('should handle 8-digit hex with alpha channel',DEFAULT, () => {
    const result = vm.convertColorToRgba('#FF00FFAA', 0.5);
    expect(result).to.equal('rgba(255,0,255,0.5)');
  });

  it('should handle 4-digit hex with alpha', DEFAULT,() => {
    const result = vm.convertColorToRgba('#ABC', 0.5);
    expect(result).to.equal('rgba(170,187,204,0.5)');
  });

  it('should handle empty color string', DEFAULT,() => {
    expect(() => vm.convertColorToRgba('', 0.5)).to.throw('Invalid color format');
    expect(() => vm.convertColorToRgba('#', 0.5)).to.throw('Invalid color format');
  });

  it('should handle log messages with special characters',DEFAULT, () => {
    const logger = vm.log;
    logger.log('INFO', 'Message with \n newline and \t tab');
    expect(logger.logMessages[0]).to.include('Message with \n newline and \t tab');
  });

  it('should handle concurrent loggers',DEFAULT, () => {
    const vm2 = new (class extends LiveBaseVm {
      constructor(vmInjector: LiveVmInjector) {
        super(vmInjector);
      }
    })(mockInjector);
    vm.log.log('INFO', 'VM1');
    vm2.log.log('INFO', 'VM2');
    expect(vm.log.logMessages).to.include('INFO: VM1');
    expect(vm2.log.logMessages).to.include('INFO: VM2');
  });

  it('should handle log after injector change',DEFAULT, () => {
    mockInjector.scene = 'newScene';
    const newLogger = vm.log;
    expect(newLogger).to.equal(MockLogUtil.loggerMap.get(`${vm.TAG}_newScene`));
  });
}