//
//  CalculationService.m
//  Calculator
//
//  Created by Ричард Попов on 19.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "CalculationService.h"

@implementation CalculationService

struct vertex  // точка
{
    double x,y; // координаты
    int def;	// флаг того, что координаты точки определены
};

const int Nmax = 100; // максимальное число узловых точек на потолке
struct vertex coord[Nmax]; // массив узловых точек потолка
int N,i,j;
double dliny[Nmax][Nmax];

-(NSMutableArray*)getCoords:(Plot *)plot
{
    [self initValues:plot];
    [self calcCoords];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int k = 0; k < N; k++) {
        CoordModel *point = [[CoordModel alloc] init];
        point.x = coord[k].x;
        point.y = coord[k].y;
        
        [array addObject:point];
    }
    
    return array;
}

-(NSString*)getLetterByNumber:(int)num
{
    char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    return [NSString stringWithFormat:@"%c", alphabet[num - 1]];
}

-(int)getNumberByLetter:(NSString *)letter
{
    char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    for (int k = 0; k < 27; k++) {
        if ([letter isEqualToString:[NSString stringWithFormat:@"%c", alphabet[k]]])
        {
            return k + 1;
        }
    }
}

-(float)getValueFromSideArray:(NSArray *)array ByFirstPoint:(int)first AndSecondPoint:(int)second
{
    for (int k = 0; k < array.count; k++) {
        PlotSide *tmpSide = [array objectAtIndex:k];
        
        if ([tmpSide.angleFirst isEqualToString:[self getLetterByNumber:first + 1]] && [tmpSide.angleSecond isEqualToString:[self getLetterByNumber:second + 1]]) {
            return [tmpSide.sideWidth floatValue];
        }
    }
}

-(float)getValueFromDiagonalArray:(NSArray *)array ByFirstPoint:(int)first AndSecondPoint:(int)second
{
    for (int k = 0; k < array.count; k++) {
        PlotDiagonal *tmpSide = [array objectAtIndex:k];
        
        if ([tmpSide.angleFirst isEqualToString:[self getLetterByNumber:first + 1]] && [tmpSide.angleSecond isEqualToString:[self getLetterByNumber:second + 1]]) {
            return [tmpSide.diagonalWidth floatValue];
        }
    }
}

-(void)initValues:(Plot *)plot{
    // обнуление массивов
    for (i = 0; i < Nmax; i++)
        for (j = 0; j < Nmax; j++)
        {
            dliny[i][j] = -1; // если длина меньше нуля, считаем длину между этими точками не заданной
        }
    
    for (i = 0; i < Nmax; i++) //обнуляем координаты всех точек
    {
        coord[i].x = 0;
        coord[i].y = 0;
        coord[i].def = 0;
    }
    
    coord[0].x = 0; // задаем явно координаты первой точки равными нулю, ибо все равно где поместить начало координат
    coord[0].y = 0;
    coord[0].def = 1; // считаем точку определенной
    
    // кол-во точек
    N = [plot.plotSide allObjects].count;
    
    // массивы с данными сторон и диагоналей
    NSArray *sideArray = [[NSArray alloc] init];
    NSArray *diagonalArray = [[NSArray alloc] init];
    sideArray = [plot.plotSide allObjects];
    diagonalArray = [plot.plotDiagonal allObjects];
    
    

    double l;
    for (i = 0; i < N; i++)
    {
        if (i + 1 < N) // для всех сегментов кроме последнего
        {
            l = [self getValueFromSideArray:sideArray ByFirstPoint:i AndSecondPoint:i + 1];
            
            dliny[i][i + 1] = l; // задаем расстояние между точкой А и В
            dliny[i+1][i]= l; // оно же расстояние между В и А
        }
        else // для последнего сегмента
        {
            l = [self getValueFromSideArray:sideArray ByFirstPoint:i AndSecondPoint:i + 1];
            
            dliny[i][0] = l;
            dliny[0][i] = l;
        }
        
    }
    
    coord[1].x = dliny[0][1]; // полагаем, что вторая лежит правее первой точки
    coord[1].y = 0;
    coord[1].def = 1;
    
    if (diagonalArray.count < N -3)
    {
        NSLog(@"Ошибка данных: неверное количество координат в чертеже");
    }
    
    for (int k = 0; k < (N - 3); k++)
    {
        PlotDiagonal *tmpDiagonal = [diagonalArray objectAtIndex:k];
        
        i = [self getNumberByLetter:tmpDiagonal.angleFirst];
        j = [self getNumberByLetter:tmpDiagonal.angleSecond];
        l = [self getValueFromDiagonalArray:diagonalArray ByFirstPoint:i - 1 AndSecondPoint:j - 1];
        
        i--;j--;
        if (dliny[i][j] < 0)
        {
            dliny[i][j] = l; // задаем длину диагонали между заданными точками
            dliny[j][i] = l;
        }
        else
        {
            k--;
        }
    }
}

-(void)calcCoords
{
    // алгоритм
    
    int A = 0;
    int B = 1;
    int n = N - 2;
    int C;
    int count = 0;
    do // пробегаем все неопределенные точки
    {
        C = 0;
        do // ищем через какие точки их можем определеить
        {
            C++;
            count = 0;
            if (coord[C].def == 0)
                for (i = 0; i < N; i++)
                    if ((dliny[C][i] > 0.0) && (coord[i].def == 1))
                    {
                        count++;
                        if (count == 1)
                            A = i;
                        if (count == 2)
                            B = i;
                    }
            if (C >= N) count = Nmax + 2; // если мы не нашли через какую точку определить неизвестную, то такого не может быть или диагонали пересекаются
        } while (count < 2) ;
        
        if (count == Nmax + 2)
        {
            NSLog(@"Ошибка данных: диагонали пересекаются");
            return;
        }
        
        if (((A < C) && (C < B)) || ((B < A) && (A < C)) || ((C < B) && (B < A))) // три точки должны идти по часовой стрелке, если не так, то меняем направление
        {
            int temp = B;
            B = A;
            A = temp;
        }
        
        n--;
        
        double r1, r2, d, a, h, x1, y1, x2, y2, x0, y0; // магия!!
        
        r1 = dliny[C][A];
        r2 = dliny[C][B];
        x1 = coord[A].x;
        y1 = coord[A].y;
        x2 = coord[B].x;
        y2 = coord[B].y;
        d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)); // все еще магия
        
        if (d > r1 + r2)
        {
            NSLog(@"Ошибка данных: Вы ввели неправильные длины между точками: %d %d %d", A, B, C);
            return;
        }
        
        a = (r1 * r1 - r2 * r2 + d * d) / (2.0 * d);
        h = sqrt(r1 * r1 - a * a);
        x0 = x1 + a * (x2 - x1) / d;
        y0 = y1 + a * (y2 - y1)/ d;
        coord[C].x = x0 - h * (y2 - y1) / d;
        coord[C].y = y0 + h * (x2 - x1) / d;
        coord[C].def = 1; // считаем точку определенной
        // cout <<"C.x:"<<coord[C].x<<" C.y:"<<coord[C].y<<endl;
        
    } while (n > 0);
    //---------------------------------------
    
    
    // перенос в первый квадрант
    double minx, miny;
    minx = 0; miny = 0;
    for (i = 0; i < N; i++) // находим самую нижнюю и самую левую точки
    {
        if (coord[i].x < minx)
            minx = coord[i].x;
        if (coord[i].y < miny)
            miny=coord[i].y;
    }
    
    for (i = 0; i < N; i++) // сдвигаем в правый квадрант
    {
        coord[i].x -= minx;
        coord[i].y -= miny;
    }
}

@end
