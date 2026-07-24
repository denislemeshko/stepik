classes = {}

with open("dataset_3380_5.txt", encoding="utf-8") as file:
    for line in file:
        parts = line.strip().split("\t")

        grade = int(parts[0])
        height = int(parts[2])

        if grade not in classes:
            classes[grade] = [0, 0]

        classes[grade][0] += height
        classes[grade][1] += 1

with open("answer.txt", "w", encoding="utf-8") as out:
    for grade in range(1, 12):
        if grade in classes:
            average = classes[grade][0] / classes[grade][1]
            out.write(f"{grade} {average}\n")
        else:
            out.write(f"{grade} -\n")