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
import systemDateTime from '@ohos.systemDateTime';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'HighFrequencyCallStatistics';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 统计场景结果类
 */
export class Statistics {
    private scene: string | undefined = undefined;
    private triggerTime: number[] = [];
    private warned: boolean = false;
    /* 暂定1秒同场景调用5次，按照高频告警，给每次200ms的刷新时间 */
    public static readonly FREQ_TIME = 1;
    public static readonly MAX_CALL_FREQ = 5;
    private static readonly MAX_FREQ = 10000;
    private static readonly NULL_TRIGGER_TIMES = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    constructor() {
        this.init(undefined);
    }

    /**
     * 绑定选择当前统计类
     * @param scene 场景名称
     */
    public init(scene: string | undefined): void {
        if (!this.isNull()) {
            log.showWarn(`SCENE: Initialing used-scene ${this.scene} is undesirable.`);
        }
        if (this.triggerTime.length === 0) {
            this.triggerTime.push(...Statistics.NULL_TRIGGER_TIMES);
        } else {
            this.triggerTime.fill(0);
        }
        this.scene = scene;
        this.warned = false;
    }

    /**
     * 记录1次触发事件
     * @param now 当前时间，推荐启动时间
     */
    public record(now: number): void {
        let pos: number = this.findTriggerPosition();
        log.showDebug('Find available trigger position %{public}d on %{public}s.', pos, this.scene);
        this.triggerTime[pos] = now;
        if (this.check(now)) {
            this.warn();
            this.warned = true;
        }
    }

    /**
     * 清理已经告警过的统计类，可用于后续复用绑定
     */
    public clean(): void {
        if (this.warned) {
            log.showDebug('Recycle scene %{public}s items.', this.scene);
            this.init('');
        }
    }

    /**
     * 获取事件触发频率
     * @param end 结束时间
     * @returns 频率值，最高不超过Statistics.MAX_FREQ
     */
    public getTriggerFrequency(end: number): number {
        /* 统计1s内的使用频率 */
        let start = end - (Statistics.FREQ_TIME * 1000);
        if (start <= 0) {
          start = 1;
        }
        let count = this.getTriggerCount(start, end);

        return Math.min((count / Statistics.FREQ_TIME), Statistics.MAX_FREQ);
    }

    /**
     * 获取事件触发次数
     * @param start 开始事件
     * @param end 结束时间
     * @returns 触发次数
     */
    public getTriggerCount(start: number, end: number): number {
        if (this.isNull()) {
            return 0;
        }

        return this.triggerTime.reduce((total, time) => {
            return total + ((time >= start && time <= end) ? 1 : 0);
        }, 0);
    }

    /**
     * 告警
     */
    public warn(): void {
        log.showWarn(`Scene (${this.scene}) calls in high frequently:`);
        let line: string = '';
        this.triggerTime.forEach((time, index) => {
            if (index > 0) {
                if (index % 5 === 0) {
                    log.showWarn('%{public}s', line);
                    line = '';
                } else {
                  line += ', ';
                }
            }
            line += `${time}`;
        });
        if (line.length > 0) {
            log.showWarn('%{public}s', line);
        }
    }

    /**
     * DT用于检测结果用
     * @returns 触发时机数组
     */
    public getTriggerTimes(): number[] {
        return this.triggerTime;
    }

    /**
     * DT用于检测结果用
     * @returns 触发时机数组
     */
    public isWarned(): boolean {
        return this.warned;
    }

    /**
     * DT用于检测结果用
     * @returns 场景名称
     */
    public getScene(): string | undefined {
        return this.scene;
    }

    private isNull(): boolean {
        return this.scene === undefined;
    }

    private isHighFrequency(now: number): boolean {
        let freq: number = this.getTriggerFrequency(now);

        return freq > Statistics.MAX_CALL_FREQ;
    }

    private check(now: number): boolean {
        /* 抽离判断规则，后续容易扩展 */
        return this.isHighFrequency(now);
    }

    private findTriggerPosition(): number {
        if (this.isNull()) {
            return 0;
        }

        let pos = 0;
        let min = this.triggerTime[pos];
        this.triggerTime.forEach((time, index) => {
            if (time < min) {
                min = time;
                pos = index;
            }
        });

        return pos;
    }
}

/**
 * 高频触发的DFX统计模块
 * 当前支持2种告警：
 * 1. 所有统计场景1s调用超过5次(HighFrequencyCallStatistics.MAX_CALL_FREQ)，告警
 * 2. 单一统计场景1s调用超过5次(Statistics.MAX_CALL_FREQ)，告警
 */
export class HighFrequencyCallStatistics {
    /* 暂定1秒不同场景累计调用5次，按照高频告警，给每次200ms的刷新时间 */
    public static readonly FREQ_TIME = 1;
    public static readonly MAX_CALL_FREQ = 5;
    private scenes: Statistics[] = [];

    constructor(size: number) {
        let newSize = Math.max(1, size);
        for (let i = 0; i < newSize; i++) {
            this.scenes.push(new Statistics());
        }
    }

    /**
     * 记录1次事件触发
     * @param scene 触发场景
     * @param time 触发时间（毫秒），不传递则自动获取当前系统启动时间
     */
    public record(scene: string, time?: number): boolean {
        if (!scene) {
            return false;
        }
        const now: number =
            (time !== undefined ? time : systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false));
        this.findScene(scene, now).record(now);
        const warn = this.checkAll(now);
        this.cleanWarned();
        log.showInfo(`record scene ${scene} at ${now} as ${warn ? 'WARNING' : 'NORMAL'}`);
        return warn;
    }

    /**
     * DT用于检测结果数组
     * @returns 结果数组
     */
    public getScenes(): Statistics[] {
        return this.scenes;
    }

    private findLowestFrequencyScene(now: number): Statistics {
        let scene: Statistics = this.scenes[0];
        let minFreq = this.scenes[0].getTriggerFrequency(now);

        this.scenes.forEach((item) => {
            let freq = item.getTriggerFrequency(now);
            log.showDebug('check scene %{public}s frequency %{public}d vs %{public}d', scene.getScene(), freq, minFreq);
            if (freq < minFreq) {
                minFreq = freq;
                scene = item;
            }
        });

        log.showDebug('select scene %{public}s because lowest frequency %{public}d', scene.getScene(), minFreq);
        return scene;
    }

    private findSceneByName(scene: string): Statistics | undefined {
        return this.scenes.find((item) => {
            return item.getScene() === scene;
        });
    }

    private findScene(scene: string, now: number): Statistics {
        let item = this.findSceneByName(scene);
        if (!item) {
            /**
             * 这里有2种方案：
             * 1. 先找空的，再找频率最低的
             * 2. 直接找频率最低的
             *
             * 其差异点是，如果先填充了一组场景数据，但是极其低频，再来一组场景数据的时候，先前的低频数据是否可以清空？
             * 对于单组场景数据检查来说，可以清空，因为已经认定是低频的；
             * 但是对于多组数据检查来说，建议是保留，因为低频也可能影响自身
             *
             * 而当前的实现，是按方案2开始来实现的，但是支持了上述2个检查，因为这里的最低频值是0，所以对多组数据检查来说，就是冗余数据
             */
            item = this.findLowestFrequencyScene(now);
            item.init(scene);
        }

        return item;
    }

    private checkAll(now: number): boolean {
        let start = now - HighFrequencyCallStatistics.FREQ_TIME * 1000;
        if (start <= 0) {
            start = 1;
        }
        let count = this.scenes.reduce((total, scene) => {
            return total + scene.getTriggerCount(start, now);
        }, 0);
        let freq = count / HighFrequencyCallStatistics.FREQ_TIME;
        if (freq > HighFrequencyCallStatistics.MAX_CALL_FREQ) {
            log.showWarn(`Total scene calls in high frequently ${freq}.
                Show each infomation of scene below.`);
            this.scenes.forEach((scene) => {
                scene.warn();
            });
            return true;
        }
        return false;
    }

    private cleanWarned(): void {
        this.scenes.forEach((item) => {
            item.clean();
        });
    }
}